<script setup lang="ts">
import { computed, ref, watch } from "vue";

// THEME COLORS
const COLOR_PRIMARY = "#1976D2";
const COLOR_ACCENT = "#FFC107";
const COLOR_SECONDARY = "#424242";

// BOARD STATE
const board = ref<(null | "X" | "O")[]>(Array(9).fill(null));
const currentPlayer = ref<"X" | "O">("X");
const winner = ref<null | "X" | "O">(null);
const gameOver = ref(false);
const winningCombo = ref<number[] | null>(null);
const isDraw = ref(false);

// PUBLIC_INTERFACE
function cellLabel(idx: number): string {
  return board.value[idx] || "-";
}

// PUBLIC_INTERFACE
function handleCellClick(idx: number) {
  if (board.value[idx] !== null || winner.value || gameOver.value) return;
  board.value[idx] = currentPlayer.value;
  checkGameEnd();
  if (!winner.value && !isDraw.value) {
    currentPlayer.value = currentPlayer.value === "X" ? "O" : "X";
  }
}

function checkGameEnd() {
  // Check for winner
  const combos = [
    [0,1,2],[3,4,5],[6,7,8], // rows
    [0,3,6],[1,4,7],[2,5,8], // columns
    [0,4,8],[2,4,6]          // diagonals
  ];
  for (const combo of combos) {
    const [a,b,c] = combo;
    if (
      board.value[a] &&
      board.value[a] === board.value[b] &&
      board.value[a] === board.value[c]
    ) {
      winner.value = board.value[a];
      winningCombo.value = combo;
      gameOver.value = true;
      return;
    }
  }
  // Check for draw
  if (board.value.every(cell => cell !== null)) {
    isDraw.value = true;
    gameOver.value = true;
  }
}

function resetGame() {
  board.value = Array(9).fill(null);
  currentPlayer.value = "X";
  winner.value = null;
  winningCombo.value = null;
  gameOver.value = false;
  isDraw.value = false;
}

const gameStatus = computed(() => {
  if (winner.value) return `Player ${winner.value} wins! 🎉`;
  if (isDraw.value) return "It's a draw! 🤝";
  return `Player ${currentPlayer.value}'s turn`;
});
</script>

<template>
  <div class="ttt-container">
    <div class="ttt-board">
      <button
        v-for="(cell, idx) in board"
        :key="idx"
        class="ttt-cell"
        :class="{
          winner: winningCombo && winningCombo.includes(idx),
        }"
        :disabled="!!cell || gameOver"
        @click="handleCellClick(idx)"
        :aria-label="'Cell ' + (idx + 1) + ': ' + (cellLabel(idx) === '-' ? 'empty' : cellLabel(idx))"
      >
        <span class="ttt-mark" :class="cell">{{ cellLabel(idx) }}</span>
      </button>
    </div>
    <div class="ttt-status">
      <span :class="{'winner-text': winner, 'draw-text': isDraw}">
        {{ gameStatus }}
      </span>
    </div>
    <div class="ttt-controls">
      <button class="reset-btn" @click="resetGame">
        Restart Game
      </button>
    </div>
  </div>
</template>

<style scoped>
.ttt-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 70vh;
  padding: 2rem 1rem;
  background: var(--color-background, #fff);
}

.ttt-board {
  display: grid;
  grid-template-columns: repeat(3, 70px);
  grid-template-rows: repeat(3, 70px);
  gap: 8px;
  background: #f8f8f8;
  border-radius: 16px;
  box-shadow: 0 2px 8px rgba(66, 66, 66, 0.07);
  margin-bottom: 2rem;
}

.ttt-cell {
  background: #fff;
  border: 2px solid var(--color-border, #E0E0E0);
  border-radius: 12px;
  outline: none;
  font-size: 2.2rem;
  font-weight: 500;
  color: ${COLOR_PRIMARY};
  cursor: pointer;
  transition: box-shadow 0.1s, border 0.1s, background 0.1s;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 70px;
  width: 70px;
  position: relative;
}
.ttt-cell .ttt-mark.X {
  color: ${COLOR_PRIMARY};
}
.ttt-cell .ttt-mark.O {
  color: ${COLOR_ACCENT};
}
.ttt-cell:disabled {
  background: #f1f1f1;
  cursor: not-allowed;
  color: ${COLOR_SECONDARY};
}
.ttt-cell.winner {
  background: ${COLOR_ACCENT}33;
  border-color: ${COLOR_ACCENT};
  animation: winpulse 0.6s alternate 2;
}
@keyframes winpulse {
  0% { box-shadow: 0 0 0 0 ${COLOR_ACCENT}70; }
  100% { box-shadow: 0 0 12px 6px ${COLOR_ACCENT}99; }
}
.ttt-status {
  margin-bottom: 1rem;
  font-size: 1.15rem;
  min-height: 1.5em;
  letter-spacing: 0.03em;
  font-weight: 500;
  color: ${COLOR_PRIMARY};
  text-align: center;
}
.winner-text {
  color: ${COLOR_ACCENT};
}
.draw-text {
  color: ${COLOR_SECONDARY};
}
.ttt-controls {
  margin-top: 0.5rem;
  width: 100%;
  display: flex;
  justify-content: center;
}
.reset-btn {
  all: unset;
  cursor: pointer;
  background: ${COLOR_PRIMARY};
  color: #fff;
  font-size: 1rem;
  padding: 0.55em 1.6em;
  border-radius: 8px;
  transition: background 0.15s;
  font-weight: bold;
  letter-spacing: 0.04em;
  box-shadow: 0 1px 4px 0 #8881;
}
.reset-btn:hover, .reset-btn:active {
  background: ${COLOR_ACCENT};
  color: #333;
}

@media (max-width: 600px) {
  .ttt-board {
    grid-template-columns: repeat(3, 55px);
    grid-template-rows: repeat(3, 55px);
    gap: 6px;
  }
  .ttt-cell {
    height: 55px;
    width: 55px;
    font-size: 1.6rem;
    border-radius: 7px;
  }
  .ttt-controls {
    margin-top: 1rem;
  }
}
</style>
