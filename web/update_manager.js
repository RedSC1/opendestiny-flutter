(function () {
  if (!('serviceWorker' in navigator)) {
    return;
  }

  const localInfo = window.__OD_BUILD_INFO__ || {};
  const locale = (navigator.language || 'zh-CN').toLowerCase();
  const isZh = locale.startsWith('zh');
  const copy = isZh
    ? {
        title: '发现网页更新',
        body: '检测到网页更新，刷新后即可使用最新内容。',
        action: '立即刷新',
        close: '稍后',
      }
    : {
        title: 'Update available',
        body: 'A newer web build is ready. Refresh to use the latest version.',
        action: 'Refresh now',
        close: 'Later',
      };

  let currentRegistration = null;
  let bannerVisible = false;
  let pendingRemoteInfo = null;
  let isRefreshing = false;
  let dismissedBuildKey = null;
  const versionFetchRetryCount = 3;
  const versionFetchRetryDelayMs = 1200;
  window.__OD_LAST_UPDATE_CHECK_RESULT__ = 'idle';

  function rootVersionUrl() {
    return new URL('../version.json', document.baseURI).toString();
  }

  function buildMessage(remoteInfo) {
    if (remoteInfo && remoteInfo.version) {
      return isZh
        ? `${copy.body} 当前线上版本 ${remoteInfo.version}。`
        : `${copy.body} Latest version: ${remoteInfo.version}.`;
    }
    return copy.body;
  }

  function buildKey(remoteInfo) {
    return (remoteInfo && remoteInfo.webBuild) || '__waiting__';
  }

  function ensureBanner(remoteInfo) {
    if (bannerVisible) {
      return;
    }

    const wrapper = document.createElement('div');
    wrapper.id = 'od-update-banner';
    wrapper.style.position = 'fixed';
    wrapper.style.left = '16px';
    wrapper.style.right = '16px';
    wrapper.style.bottom = '16px';
    wrapper.style.zIndex = '2147483647';
    wrapper.style.display = 'flex';
    wrapper.style.justifyContent = 'center';
    wrapper.style.pointerEvents = 'none';

    const card = document.createElement('div');
    card.style.maxWidth = '560px';
    card.style.width = '100%';
    card.style.background = 'rgba(7, 11, 22, 0.94)';
    card.style.color = '#f5f7fb';
    card.style.border = '1px solid rgba(255, 255, 255, 0.12)';
    card.style.borderRadius = '16px';
    card.style.boxShadow = '0 18px 48px rgba(0, 0, 0, 0.35)';
    card.style.padding = '14px 16px';
    card.style.pointerEvents = 'auto';
    card.style.backdropFilter = 'blur(12px)';

    const title = document.createElement('div');
    title.textContent = copy.title;
    title.style.fontSize = '15px';
    title.style.fontWeight = '700';
    title.style.marginBottom = '6px';

    const body = document.createElement('div');
    body.textContent = buildMessage(remoteInfo);
    body.style.fontSize = '13px';
    body.style.lineHeight = '1.5';
    body.style.opacity = '0.92';

    const actions = document.createElement('div');
    actions.style.display = 'flex';
    actions.style.justifyContent = 'flex-end';
    actions.style.gap = '10px';
    actions.style.marginTop = '12px';

    const closeButton = document.createElement('button');
    closeButton.type = 'button';
    closeButton.textContent = copy.close;
    closeButton.style.background = 'transparent';
    closeButton.style.color = '#d8dfef';
    closeButton.style.border = '1px solid rgba(255, 255, 255, 0.18)';
    closeButton.style.borderRadius = '999px';
    closeButton.style.padding = '8px 14px';
    closeButton.style.cursor = 'pointer';
    closeButton.onclick = function () {
      dismissedBuildKey = buildKey(remoteInfo);
      wrapper.remove();
      bannerVisible = false;
    };

    const refreshButton = document.createElement('button');
    refreshButton.type = 'button';
    refreshButton.textContent = copy.action;
    refreshButton.style.background = '#f6c453';
    refreshButton.style.color = '#1d1606';
    refreshButton.style.border = 'none';
    refreshButton.style.borderRadius = '999px';
    refreshButton.style.padding = '8px 14px';
    refreshButton.style.fontWeight = '700';
    refreshButton.style.cursor = 'pointer';
    refreshButton.onclick = function () {
      activateUpdate();
    };

    actions.appendChild(closeButton);
    actions.appendChild(refreshButton);
    card.appendChild(title);
    card.appendChild(body);
    card.appendChild(actions);
    wrapper.appendChild(card);
    document.body.appendChild(wrapper);
    bannerVisible = true;
  }

  function activateUpdate() {
    if (isRefreshing) {
      return;
    }
    isRefreshing = true;

    const registration = currentRegistration;
    if (registration && registration.waiting) {
      let reloadFallback = null;
      const handleControllerChange = function () {
        if (reloadFallback !== null) {
          clearTimeout(reloadFallback);
        }
        window.location.reload();
      };

      navigator.serviceWorker.addEventListener(
        'controllerchange',
        handleControllerChange,
        { once: true }
      );

      reloadFallback = window.setTimeout(function () {
        window.location.reload();
      }, 3000);

      registration.waiting.postMessage('skipWaiting');
      return;
    }

    window.location.reload();
  }

  function maybeShowBanner(remoteInfo) {
    pendingRemoteInfo = remoteInfo || pendingRemoteInfo;
    if (dismissedBuildKey === buildKey(pendingRemoteInfo)) {
      return;
    }
    ensureBanner(pendingRemoteInfo);
  }

  function watchRegistration(registration) {
    if (!registration || registration.__odWatching) {
      return;
    }
    registration.__odWatching = true;
    currentRegistration = registration;

    if (registration.waiting) {
      maybeShowBanner();
    }

    registration.addEventListener('updatefound', function () {
      const installing = registration.installing;
      if (!installing) {
        return;
      }

      installing.addEventListener('statechange', function () {
        if (
          installing.state === 'installed' &&
          navigator.serviceWorker.controller
        ) {
          maybeShowBanner();
        }
      });
    });
  }

  async function resolveRegistration() {
    for (let i = 0; i < 10; i += 1) {
      const registration = await navigator.serviceWorker.getRegistration();
      if (registration) {
        watchRegistration(registration);
        return registration;
      }
      await new Promise((resolve) => window.setTimeout(resolve, 500));
    }
    return null;
  }

  async function fetchRemoteInfo() {
    for (let attempt = 0; attempt < versionFetchRetryCount; attempt += 1) {
      try {
        const response = await fetch(
          rootVersionUrl() + '?ts=' + Date.now(),
          { cache: 'no-store' }
        );
        if (response.ok) {
          return await response.json();
        }
      } catch (_) {
        // Ignore and retry a few times on transient network failures.
      }

      if (attempt < versionFetchRetryCount - 1) {
        await new Promise((resolve) =>
          window.setTimeout(resolve, versionFetchRetryDelayMs)
        );
      }
    }
    return null;
  }

  async function checkForUpdates() {
    const registration = currentRegistration || (await resolveRegistration());
    if (!registration) {
      return 'error';
    }

    if (registration.waiting) {
      maybeShowBanner();
      return 'update';
    }

    const remoteInfo = await fetchRemoteInfo();
    if (!remoteInfo) {
      return 'error';
    }

    if (
      remoteInfo.webBuild &&
      localInfo.webBuild &&
      remoteInfo.webBuild !== localInfo.webBuild
    ) {
      pendingRemoteInfo = remoteInfo;
      if (dismissedBuildKey && dismissedBuildKey !== buildKey(remoteInfo)) {
        dismissedBuildKey = null;
      }
      try {
        await registration.update();
      } catch (_) {
        // Ignore update errors and fall back to a manual refresh prompt.
      }

      window.setTimeout(function () {
        if (registration.waiting) {
          maybeShowBanner(remoteInfo);
        } else {
          maybeShowBanner(remoteInfo);
        }
      }, 1200);
      return 'update';
    }

    try {
      await registration.update();
    } catch (_) {
      // Ignore transient update errors.
    }
    return 'latest';
  }

  window.__OD_CHECK_WEB_UPDATE__ = function () {
    window.__OD_LAST_UPDATE_CHECK_RESULT__ = 'pending';
    checkForUpdates()
      .then(function (result) {
        window.__OD_LAST_UPDATE_CHECK_RESULT__ = result || 'error';
      })
      .catch(function () {
        window.__OD_LAST_UPDATE_CHECK_RESULT__ = 'error';
      });
    return 'pending';
  };

  window.__OD_ACTIVATE_WEB_UPDATE__ = function () {
    activateUpdate();
    return 'refreshing';
  };

  window.addEventListener('load', function () {
    resolveRegistration().then(function (registration) {
      if (registration) {
        watchRegistration(registration);
      }

      window.setTimeout(checkForUpdates, 1600);
    });
  });
})();
