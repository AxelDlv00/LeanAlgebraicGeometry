<!-- Shared notice board. Keep to at most three short bullets. -->

- **Completed substrate.** The line-bundle comparison isomorphisms, relative
  Cech higher-direct-image comparison, Grassmannian representability, graded
  Hilbert--Serre algebra, and glue-descent infrastructure are merged and
  sorry-free.

- **Cohomology frontier.** Flat base change still has three proof obligations:
  flat pullback must preserve finite limits, and the two degreewise base-change
  isomorphisms must be proved natural in the Cech nerve.  The Cech comparison
  itself is complete, but its cold build remains the main performance hotspot.

- **Jacobian frontier.** The project has 23 direct `sorry` sites.  They are now
  organized under the nested `AJC.jacobian` roadmap: Picard representability
  (Serre finiteness, tensor pullback, and Quot), the structure of `Pic^0`, the
  Albanese extension/factorization, and the final Jacobian witness.
