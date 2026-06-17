# Iter-040 objectives

## Lane 1 — `QcohRestrictBasicOpen.lean` [prover-mode: mathlib-build]

**Build two NEW declarations into the 0-sorry file** (first real prover attempt — iter-039 noop-dropped):

### B3 object iso — `AlgebraicGeometry.overBasicOpenIsoRestrict` (`lem:restrict_over_compat`)
- Target: `(modulesOverBasicOpenEquivalence g).inverse.obj (M.over D(g)) ≅ M.restrict (specBasicOpen g).ι`.
- Engine in hand: `modulesOverBasicOpenEquivalence g` (iter-038, axiom-clean).
- Skeleton `(SheafOfModules.pushforwardCongr ?_).app M` typechecks against the target (iter-038-verified).
- Recipe: in-file TODO lines 242–265 + blueprint B3a/b/c (`lem:restrict_over_compat`) + `analogies/bridge.md`.
- TRAP: `pushforwardCongr` leaves the site functor `F` a stuck metavariable → supply φ/ψ/F explicitly (the
  two functors are defeq, not syntactic). Close the ring-sheaf data equality `h` with explicit
  `NatTrans.ext`/`congrArg`/`Subsingleton.elim` — NOT bare `ext`/`congr 1` (kernel-soundness: those produce
  an unsound rfl-term the LSP accepts but `lake env lean` rejects). Re-verify with `lake env lean` +
  `#print axioms`.

### B4 — `AlgebraicGeometry.presentationModulesRestrictBasicOpen` (`lem:presentation_modulesRestrictBasicOpen`)
- Mechanical once B3 lands: `(presentationOverBasicOpen M U P g hg).ofIsIso (overBasicOpenIsoRestrict …).hom`,
  composed with `modulesRestrictBasicOpenIso` (`Presentation.ofIsIso.{u,u,u}`, `Quasicoherent.lean:132`).

**Stop rule:** no sorry. If B3 stalls, leave partial progress (the explicit `h` ring-sheaf data equality, or
the φ/ψ/F-pinned `pushforwardCongr` skeleton) + a precise decomposition — do NOT paper with a sorry. Avoid
the dormant Route-P assets (`tilde_restrict_basicOpen`, `tildePreservesFiniteLimits`).

## Not dispatched
- `QcohTildeSections.lean` — keystone assembly import-blocked on B3/B4 (don't exist yet). No honest lane.
- All other files DONE/off-limits (see PROGRESS `## Off-limits`).
