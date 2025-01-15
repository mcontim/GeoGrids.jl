<template>
    <Suspense>
        <VuePlotly
            :data="props.data"
            :layout="props.layout"
            :config="props.config"
        />
        <template #fallback>
            <div>Loading plot...</div>
        </template>
    </Suspense>
</template>

<script setup lang="ts">
import VuePlotly from './PlotlyWrapper.vue'
import type { Data, Layout, Config } from 'plotly.js-dist-min'

const props = defineProps<{
    data?: Data[]
    layout?: Partial<Layout>
    config?: Partial<Config>
}>()
</script> 