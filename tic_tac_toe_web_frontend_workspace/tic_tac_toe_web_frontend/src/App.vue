<script setup lang="ts">
import { RouterView } from 'vue-router'
</script>

<template>
  <header class="mini-header">
    <span class="app-title">
      <span class="ttt-x">Tic</span
      ><span class="ttt-o">Tac</span
      ><span class="ttt-x">Toe</span>
    </span>
  </header>
  <RouterView />
</template>

<style scoped>
.mini-header {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  padding: 2.2rem 0 1.2rem 0;
  background: var(--color-background, #fff);
}
.app-title {
  font-size: 2.3rem;
  font-weight: 900;
  letter-spacing: 0.04em;
  color: #1976D2;
  display: flex;
  gap: 0.16em;
  user-select: none;
}
.ttt-x {
  color: #1976D2;
}
.ttt-o {
  color: #FFC107;
}
</style>
