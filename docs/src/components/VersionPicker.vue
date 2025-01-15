<!-- Adapted from https://github.com/MakieOrg/Makie.jl/blob/master/docs/src/.vitepress/theme/VersionPicker.vue -->

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useData, withBase } from 'vitepress'
import VPNavBarMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavBarMenuGroup.vue'
import VPNavScreenMenuGroup from 'vitepress/dist/client/theme-default/components/VPNavScreenMenuGroup.vue'

// Extend the global Window interface to include DOC_VERSIONS and DOCUMENTER_CURRENT_VERSION
declare global {
  interface Window {
    DOC_VERSIONS?: string[];
    DOCUMENTER_CURRENT_VERSION?: string;
    DOCS_BASE_URL?: string;
  }
}

const props = defineProps<{
  screenMenu?: boolean
}>()

const versions = ref<Array<{ text: string, link: string }>>([]);
const currentVersion = ref('Versions');
const isClient = ref(false);
const { site } = useData()

const isLocalBuild = () => {
  return typeof window !== 'undefined' && (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1');
}

const waitForScriptsToLoad = () => {
  return new Promise<boolean>((resolve) => {
    if (isLocalBuild()) {
      resolve(false);
      return;
    }
    const checkInterval = setInterval(() => {
      if (window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        clearInterval(checkInterval);
        resolve(true);
      }
    }, 100);
    // Timeout after 5 seconds
    setTimeout(() => {
      clearInterval(checkInterval);
      resolve(false);
    }, 5000);
  });
};

const loadVersions = async () => {
  if (typeof window === 'undefined') return; // Guard for SSR
  let actualBase = (window.DOCS_BASE_URL ?? '').replace(/\/$/, '');
  actualBase = window.DOCUMENTER_CURRENT_VERSION && actualBase.endsWith('/' + window.DOCUMENTER_CURRENT_VERSION)
    ? actualBase.slice(0, -window.DOCUMENTER_CURRENT_VERSION.length - 1)
    : actualBase;
  actualBase = `${window.location.origin}${actualBase.startsWith('/') ? actualBase : '/' + actualBase}`;

  let useFallback = true;
  try {
    if (!isLocalBuild()) {
      // For non-local builds, wait for scripts to load
      const scriptsLoaded = await waitForScriptsToLoad();
      if (scriptsLoaded && window.DOC_VERSIONS && window.DOCUMENTER_CURRENT_VERSION) {
        versions.value = window.DOC_VERSIONS.map((v: string) => ({
          text: v,
          link: `${actualBase}/${v}/`,
          target: '_self'
        }));
        currentVersion.value = window.DOCUMENTER_CURRENT_VERSION;
        useFallback = false;
      }
    }
  } catch (error) {
    console.warn('Error loading versions:', error);
  }

  if(useFallback) {
    const fallbackVersions = ['dev'];
    versions.value = fallbackVersions.map(v => ({
      text: v,
      link: `${actualBase}/`,
      target: '_self'
    }));
    currentVersion.value = 'dev';
  }

  isClient.value = true;
};

onMounted(loadVersions);
</script>

<template>
  <template v-if="isClient">
    <VPNavBarMenuGroup
      v-if="!screenMenu && versions.length > 0"
      :item="{ text: currentVersion, items: versions }"
      class="VPVersionPicker"
    />
    <VPNavScreenMenuGroup
      v-else-if="screenMenu && versions.length > 0"
      :text="currentVersion"
      :items="versions"
      class="VPVersionPicker"
    />
  </template>
</template>

<style scoped>
.VPVersionPicker :deep(button .text) {
  color: var(--vp-c-text-1) !important;
}
.VPVersionPicker:hover :deep(button .text) {
  color: var(--vp-c-text-2) !important;
}
</style>
