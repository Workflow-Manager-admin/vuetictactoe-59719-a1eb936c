<script setup lang="ts">
import TicTacToeGame from '../components/TicTacToeGame.vue'
</script>

<template>
  <main class="home-main">
    <TicTacToeGame />
  </main>
</template>

<style scoped>
.home-main {
  width: 100vw;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #fafbfc;
}
</style>
