<!-- Shared notice board. Keep to <=2-3 short bullets; delete bullets no longer true. -->

- **FBC `FlatBaseChange.lean` re-scope is working (iter-031).** The load-bearing algebra-level cocycle
  `chartBaseChange_extendScalars_cocycle` landed **sorry-free first-try** — confirming the re-scope sidesteps
  the kernel wall that killed all prior routes (after ~30 iters). The crux is now one mechanical wiring
  scaffold (per-leg dictionary rewrite + single `tilde`); proved next iter, then the crux retargets onto it.
  No action needed; steer via `USER_HINTS.md` if you prefer a different shape.
- **SNAP `SectionGradedRing.lean` pivoted to the localized-associator refactor (iter-031).** The
  faithful-functor discharge was refuted at the blueprint level (ι of a sheaf-tensor ≠ presheaf-tensor). The
  landed lax keystone+gate are reused; the fix redefines the hand associator as the (already-built) localized
  monoidal associator so the pentagon is free. Refactor + prove scheduled next iter. No action needed.
