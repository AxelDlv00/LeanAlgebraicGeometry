# Recommendations for the next plan iteration (post iter-038)

## Closest-to-completion target — prioritize
- **`overBasicOpenIsoRestrict` (Route B step B3 object iso), `QcohRestrictBasicOpen.lean`.** The B3b
  engine `modulesOverBasicOpenEquivalence` landed axiom-clean this iter; the object iso is the only
  remaining B3 piece and is a **bounded mechanical step**, fully recipe'd in the in-file TODO (lines
  242–265). Recipe: `(SheafOfModules.pushforwardCongr h).app M` with the site functor `F` (and φ/ψ)
  supplied **explicitly** — `pushforwardCongr` leaves `F` a stuck metavariable (`Functor.IsContinuous
  ?F …`); the candidate functors are defeq, not syntactic. Then `h` is a ring-sheaf data equality via
  `ext` + `Scheme.Opens.ι_appIso` (`= Iso.refl`). B4 `presentationModulesRestrictBasicOpen` is mechanical
  after it (`Presentation.map` along `pushforward (basicOpenIsoSpecAway g).inv ⋙ e.inverse`, then
  `Presentation.ofIsIso`). Dispatch a single `mathlib-build` lane on this file next iter.

## Blueprint coverage actions (planner / blueprint-writer) — both MAJOR from lean-vs-blueprint-checker
1. **Give `modulesOverBasicOpenEquivalence` a trackable blueprint node.** It is the central B3b
   deliverable of this iter but has no `\lean{}` pin, so `sync_leanok` cannot see the milestone. The
   checker recommends a separate definition block `\begin{definition}[B3b engine
   equivalence]\label{def:modules_over_basicOpen_equivalence}` before `lem:restrict_over_compat`, pinning
   `\lean{AlgebraicGeometry.modulesOverBasicOpenEquivalence}`. This is the cleanest fix (separates engine
   from the assembled bridge). Report: `task_results/lean-vs-blueprint-checker-qrbo.md`.
2. **`lem:restrict_over_compat` `\lean{overBasicOpenIsoRestrict}` pin is forward-looking** (decl not yet
   built). Correct as-is (`% NOTE: to-build`, no `\leanok`); will resolve once the B3 object iso lands
   next iter. No action beyond building the decl.
3. (Minor) Optionally pin the two `overEquivalence_*_isContinuous_toScheme` instances into the
   `lem:overEquivalence_isContinuous` proof block with a one-line remark — technical plumbing, not blocking.

## Code-quality action (lean-auditor MAJOR — MEDIUM priority)
- **Migrate deprecated `CategoryTheory.Sheaf.val` → `ObjectProperty.obj`** in `QcohRestrictBasicOpen.lean`
  at lines **195, 213, 232, 239, 240** (all in this-iter decls `overBasicOpenRingHom`,
  `overBasicOpenRingInvHom`, `modulesOverBasicOpenEquivalence` H₁/H₂). Not a correctness failure today but
  will break at the next Mathlib bump. Fold into the next prover lane on this file or a small refactor.
  Report: `task_results/lean-auditor-iter038.md`.

## Coverage debt — 1-to-1 Lean↔blueprint (planner to blueprint, `archon dag-query unmatched` = 9)
Eight new this-iter Lean decls have no blueprint block (the 9th is pre-existing dead `CechAcyclic.affine`):
- `AlgebraicGeometry.modulesOverBasicOpenEquivalence` (B3b engine; **substantive — see action 1 above**).
- `AlgebraicGeometry.overForgetIso` — `Over.forget D(g) ≅ overEquivalence.functor ⋙ ι.opensFunctor`;
  depends on the private image–preimage identity + thinness of `Opens`. B3a sub-step.
- `AlgebraicGeometry.overForgetInvIso` — `= Iso.refl` (reverse datum is definitional). B3a sub-step.
- `AlgebraicGeometry.overBasicOpenRingHom` / `overBasicOpenRingInvHom` — the φ/ψ ring-sheaf comparisons
  feeding `pushforwardPushforwardEquivalence`; depend on `overForgetIso`/`overForgetInvIso`. B3a sub-steps.
- `AlgebraicGeometry.overEquivalence_functor_isContinuous_toScheme` /
  `overEquivalence_inverse_isContinuous_toScheme` — defeq instance re-statements of
  `lem:overEquivalence_isContinuous` for the `toScheme` carrier; can be folded into that node.
- `AlgebraicGeometry.specBasicOpen_ι_image_overEquivalence_functor` (private) — image–preimage identity
  helper; private, blueprint coverage optional.

## Do NOT retry / not-blocked notes
- **No stuck route, no blocked target to avoid.** Route B is converging: B1, B2 closed iter-037; B3b engine
  closed iter-038. The B3 object iso is bounded (recipe in hand), not a wall. No structural change needed.
- **Reusable pattern — thin-category coherence kernel-soundness trap**: do NOT close H₁/H₂-style coherence
  squares over `Opens`/`Over (Opens X)` with bare `ext`/`congr 1` — they can auto-close via a term the LSP
  accepts but `lake env lean` rejects (`unknown free variable _fvar…`). Use explicit
  `NatTrans.ext`/`congrArg`/`Subsingleton.elim` and confirm with `lake env lean`, never the LSP alone.
