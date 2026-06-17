# Iter-039 objectives

## Lane 1 — `QcohRestrictBasicOpen.lean` [prover-mode: mathlib-build]

**Targets (do not yet exist; build/scaffold):**
- **B3 object iso** `overBasicOpenIsoRestrict` — `M.over D(g) ≅ modulesRestrictBasicOpen g M`, assembled
  from the iter-038 engine `modulesOverBasicOpenEquivalence`.
- **B4** `presentationModulesRestrictBasicOpen` — mechanical once B3 lands.

**Blueprint:** `chapters/Cohomology_CechHigherDirectImage.tex` — `def:modules_over_basicOpen_equivalence`
(DONE engine), `lem:restrict_over_compat` (B3 object iso), `lem:presentation_modulesRestrictBasicOpen` (B4).
Statements unchanged from the iter-038 HARD-GATE-CLEAR review.

**Recipe (iter-038 prover's in-file TODO + `analogies/bridge.md`):**
- Skeleton `(SheafOfModules.pushforwardCongr ?_).app M` typechecks against the target (verified iter-038).
- Remaining = ring-sheaf data equality `h` (`ext`+`ι_appIso`), with the site functor `F` pinned explicitly
  (`pushforwardCongr` leaves `F` a stuck metavariable — the two functors are defeq, not syntactic).
- Kernel-soundness: do NOT close `h` with bare `ext`/`congr 1` (unsound rfl-term — LSP accepts, `lake env
  lean` rejects with `unknown free variable`); use `NatTrans.ext`/`congrArg`/`Subsingleton.elim`; re-verify
  with `lake env lean` + `#print axioms`.
- B4: `(presentationOverBasicOpen M U P g hg).ofIsIso (overBasicOpenIsoRestrict …).hom` + compose with
  `modulesRestrictBasicOpenIso` (`Presentation.ofIsIso.{u,u,u}`).

**Stop discipline:** no sorry. If B3 stalls, leave the `φ/ψ/F`-pinned `pushforwardCongr` skeleton or the
explicit `h` data equality + a precise decomposition. Avoid dormant Route-P assets
(`tilde_restrict_basicOpen`, `tildePreservesFiniteLimits`).

## Not dispatched (with reason)
- `QcohTildeSections.lean` — keystone-assembly import-blocked on B3/B4 (no honest second lane).
- `AffineSerreVanishing.lean` — 02KG cover-system COMPLETE; tops gated on Route B keystone.
- All other files — DONE (0-sorry) or frozen/protected.
