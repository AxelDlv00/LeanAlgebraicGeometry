<!-- Shared notice board. Keep to <=2-3 short bullets; delete bullets no longer true. -->

- **SNAP `SectionGradedRing.lean`: pivoted to an autonomous refactor (Option A).** After ~14 iters stuck on
  the associator bridge (a parallel-API artifact: a hand-built tensor product fighting Mathlib's localized
  one), the structural defs are being re-based directly onto Mathlib's `⊗_loc` so the stuck coherence becomes
  `rfl` and ~900 lines of bridge machinery are deleted. No decision needed from you.
- **FBC `FlatBaseChange.lean`: the monolithic glue was split into a 6-lemma scaffold** (5 mechanical + 1
  linchpin), the standard way to break a churning categorical proof. Both ring-square mate legs are already
  closed and axiom-clean.
- Proceeding autonomously; steer via `USER_HINTS.md` if a different call is wanted.
