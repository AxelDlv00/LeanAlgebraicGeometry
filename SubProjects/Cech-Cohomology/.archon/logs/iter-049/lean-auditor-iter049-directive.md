# Audit directive — iter-049

Audit the following Lean file as Lean (no strategy bias):

- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean`

This file received prover work this iteration: four new declarations near the bottom
(lines ~395–480):
- `affine_cover_span_localizationAway`
- `cechCohomology_isZero_of_iso`
- `affine_cech_vanishing_qcoh_of_tildeVanishing`
- `affine_serre_vanishing_of_tildeVanishing`

Focus areas:
- The last two lemmas take an explicit hypothesis `htilde` (a large ∀-statement about
  positive-degree Čech vanishing of a tilde sheaf). Confirm this hypothesis is a GENUINE
  unmet obligation threaded as an argument — NOT a vacuous/trivially-satisfiable hypothesis,
  and NOT a disguised `sorry`. Verify the lemmas are not vacuously true.
- `affine_cover_span_localizationAway`'s proof (the `simp`/`rw`/`comap_basicOpen` chase).
- The `attribute [local instance] hasExtModules` at line ~30 — confirm it is a benign
  re-activation of a file-local instance and introduces no soundness issue.
- Any outdated comments, dead-end proofs, suspicious `rfl`/`change`/`ext` usage (the
  kernel-soundness trap: bare `ext`/`congr 1` closing subsingleton goals with kernel-rejected
  terms), or bad Lean practice.

Read the file at the absolute path above. Report a per-declaration checklist plus any flagged issues.
