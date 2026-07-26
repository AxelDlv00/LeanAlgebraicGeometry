<!-- Shared notice board. Keep to at most three short bullets. -->

- **Completed substrate.** The line-bundle comparison isomorphisms, relative
  Cech higher-direct-image comparison, Grassmannian representability, graded
  Hilbert--Serre algebra, and glue-descent infrastructure are merged and
  sorry-free.  Project-wide: 153 of 164 modules are sorry-free, and 24 `sorry`
  remain in 11 modules.

- **Cohomology frontier.** Flat base change still has three proof obligations:
  flat pullback must preserve finite limits, and the two degreewise base-change
  isomorphisms must be proved natural in the Cech nerve.  The Cech comparison
  itself is complete.  On build cost the root cause is now measured: it is the
  bare `import Mathlib` carried by 86 of 164 modules (132 inherit one
  transitively), not the heartbeat budgets.

- **Jacobian frontier.** The remaining direct `sorry` sites are organized under
  the nested `AJC.jacobian` roadmap: Picard representability
  (Serre finiteness, tensor pullback, and Quot), the structure of `Pic^0`, the
  Albanese extension/factorization, and the final Jacobian witness.
