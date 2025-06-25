<script setup lang="ts">
// PUBLIC_INTERFACE
/**
 * TicTacToeGame.vue - Renders the full Tic Tac Toe game experience.
 * - Interactive player vs player logic and UI, game win/draw detection, 
 * - reset/restart support, and modern, minimal responsive styling.
 * 
 * Props: None. All state managed locally.
 */
import { ref, computed } from 'vue'

type BoardCell = 'X' | 'O' | null

const BOARD_SIZE = 3;

const emptyBoard = (): BoardCell[][] =>
  Array.from({ length: BOARD_SIZE }, () => Array(BOARD_SIZE).fill(null));

const board = ref<BoardCell[][]>(emptyBoard());
const currentPlayer = ref<'X' | 'O'>('X');
const winner = ref<null | 'X' | 'O'>(null);
const draw = ref(false);

const status = computed(() => {
  if (winner.value) return `Winner: ${winner.value}`;
  if (draw.value) return "It's a draw!";
  return `Turn: ${currentPlayer.value}`;
});

// PUBLIC_INTERFACE
function makeMove(row: number, col: number) {
  if (winner.value || draw.value || board.value[row][col]) return;
  board.value[row][col] = currentPlayer.value;
  if (checkWin(currentPlayer.value)) {
    winner.value = currentPlayer.value;
  } else if (isBoardFull()) {
    draw.value = true;
  } else {
    currentPlayer.value = currentPlayer.value === 'X' ? 'O' : 'X';
  }
}

function checkWin(player: 'X' | 'O') {
  const b = board.value;
  // Rows, cols, diags
  for (let i = 0; i < BOARD_SIZE; i++) {
    if (b[i].every(cell => cell === player)) return true; // row
    if (b.map(r => r[i]).every(cell => cell === player)) return true; // col
  }
  if ([0,1,2].every(i => b[i][i] === player)) return true;
  if ([0,1,2].every(i => b[i][2-i] === player)) return true;
  return false;
}
function isBoardFull() {
  return board.value.flat().every(cell => cell);
}

// PUBLIC_INTERFACE
function resetGame() {
  board.value = emptyBoard();
  currentPlayer.value = 'X';
  winner.value = null;
  draw.value = false;
}

</script>

<template>
  <div class="ttt-game-container">
    <div class="ttt-title">Tic Tac Toe</div>
    <div class="ttt-board" role="grid" aria-label="Tic Tac Toe Board">
      <div
        v-for="(row, rowIdx) in board"
        :key="rowIdx"
        class="ttt-row"
        role="row"
      >
        <button
          v-for="(cell, colIdx) in row"
          :key="colIdx"
          class="ttt-cell"
          :disabled="!!cell || !!winner || draw"
          role="gridcell"
          :aria-label="`row ${rowIdx + 1} column ${colIdx + 1}`"
          @click="makeMove(rowIdx, colIdx)"
        >
          <span class="ttt-cell-value" :class="{ 'cell-x': cell === 'X', 'cell-o': cell === 'O' }">{{ cell }}</span>
        </button>
      </div>
    </div>
    <div class="ttt-status">{{ status }}</div>
    <div class="ttt-controls">
      <button class="ttt-reset-btn" @click="resetGame">Reset / Restart</button>
    </div>
  </div>
</template>

<style scoped>
/* Color Theme */
:root {
  --ttt-primary: #1976D2;
  --ttt-secondary: #424242;
  --ttt-accent: #FFC107;
  --ttt-bg: #fff;
  --ttt-board-border: #ececec;
}

.ttt-game-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 60vh;
  width: 100%;
  background: var(--ttt-bg);
  box-sizing: border-box;
  padding: 2rem 0 1.5rem 0;
  border-radius: 16px;
  box-shadow: 0 4px 20px 0 #eee;
  margin: 0 auto;
  max-width: 370px;
}

.ttt-title {
  font-size: 2.2rem;
  font-weight: 700;
  letter-spacing: 2px;
  color: var(--ttt-primary);
  margin-bottom: 1.8rem;
  text-align: center;
}

.ttt-board {
  display: grid;
  grid-template-rows: repeat(3, 1fr);
  gap: 0.5rem;
  margin-bottom: 1.1rem;
  width: 320px;
  max-width: 95vw;
}

.ttt-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 0.55rem;
}

.ttt-cell {
  aspect-ratio: 1/1;
  background: var(--ttt-bg);
  border: 2px solid var(--ttt-board-border);
  border-radius: 8px;
  font-size: 2.3rem;
  font-weight: 500;
  color: var(--ttt-secondary);
  cursor: pointer;
  transition: box-shadow .15s, border-color .15s;
  outline: none;
  position: relative;
  box-shadow: 0 1px 4px 0 #f1f1f1;
}
.ttt-cell:not(:disabled):hover {
  border-color: var(--ttt-accent);
  box-shadow: 0 3px 16px 0 #fff6e0;
}

.ttt-cell:disabled {
  opacity: 0.55;
  cursor: default;
}

.ttt-cell-value.cell-x {
  color: var(--ttt-primary);
  text-shadow: 0 2px 4px #dae6f8;
}
.ttt-cell-value.cell-o {
  color: var(--ttt-accent);
  text-shadow: 0 1px 2px #fbe8b6;
}

.ttt-status {
  font-size: 1.3rem;
  font-weight: 400;
  color: var(--ttt-secondary);
  margin: 1.1rem 0 0.25rem 0;
  min-height: 2.3em;
  text-align: center;
}

.ttt-controls {
  margin-top: 0.5rem;
  width: 100%;
  display: flex;
  justify-content: center;
}

.ttt-reset-btn {
  padding: 0.6em 2.2em;
  background: var(--ttt-primary);
  color: #fff;
  font-weight: 500;
  font-size: 1rem;
  border: none;
  border-radius: 6px;
  transition: background .15s, box-shadow .16s;
  box-shadow: 0 2px 6px #edf2fa;
  cursor: pointer;
}
.ttt-reset-btn:hover,
.ttt-reset-btn:focus {
  background: var(--ttt-accent);
  color: #333;
}

@media (max-width: 450px) {
  .ttt-board {
    width: calc(100vw - 34px);
    min-width: 200px;
    max-width: 320px;
  }
  .ttt-game-container {
    padding: 1.2rem 0 1.2rem 0;
    max-width: 97vw;
  }
}
</style>
