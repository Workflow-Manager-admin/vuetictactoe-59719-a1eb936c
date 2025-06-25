<script setup lang="ts">
import TicTacToeBoard from '../components/TicTacToeBoard.vue'
</script>

<template>
  <main class="main-ttt">
    <TicTacToeBoard />
  </main>
</template>

<style scoped>
.main-ttt {
  width: 100%;
  min-height: 85vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  background: var(--color-background, #fff);
}
</style>
