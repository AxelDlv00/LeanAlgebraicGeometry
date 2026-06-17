# Session 43 (iter-043) — review summary

## Metadata
- **Session / iter:** session_43 = iter-043
- **Sorry count:** 2 → 2 (no regression). Both pre-existing frozen/superseded (dead
  `CechAcyclic.affine`, frozen P5b `CechHigherDirectImage`). Prover file
  `QcohTildeSections.lean` is **0-sorry**.
- **Build:** GREEN. Independently re-verified by review: fresh `lake env lean
  AlgebraicJacobian/Cohomology/QcohTildeSections.lean` → EXIT 0 (only `Sheaf.val` deprecation
  + long-line warnings). Both new decls report axioms `{propext, Classical.choice, Quot.sound}`.
- **Lane:** 1 planned / 1 ran (`mathlib-build`). **+2 axiom-clean decls**, 0 new sorries.
- **Targets attempted:** `tile_section_comparison` (Sub-lemma B) → `tile_section_localization`.

## Headline — the iter-042 "~150-LOC non-definitional wall" collapsed to ONE ring identity
The planner dispatched Sub-lemma B as the last tile ingredient (first genuine *construction*
attempt; iter-042 had only *confirmed* it was non-definitional). The prover did NOT build the
named targets (`tile_section_comparison` / `tile_section_localization`) — instead it landed two
axiom-clean `rfl` bridge lemmas and **reduced the entire obstruction to a single explicit
structure-sheaf ring identity**, leaving no sorry. This sharpens — and partially corrects — the
iter-042 finding and the project memory `keystone-tile-reconciliation-not-rfl`:

- iter-042 said the tile section and the F-side section are "not even the same type." That is
  true only of the **bundled** `ModuleCat R_g` vs `ModuleCat R`. iter-043 kernel-confirms the
  **underlying carriers ARE definitionally equal** via `restrict_obj`, *provided the F-side open
  is the iterated image* `W = (specBasicOpen g).ι ''ᵁ ((basicOpenIsoSpecAway g).inv ''ᵁ V)`
  (NOT yet rewritten to `D(g)`).
- Both module actions reduce to `F.val`'s `Γ(W,𝒪)`-action **by `rfl`** — the two new lemmas.

## Targets / attempts

### `modulesSpecToSheaf_smul_eq` (line ~730) — SOLVED, axiom-clean
Native `R`-action of `modulesSpecToSheaf.obj F` on a section over `W` equals
`(ringCatSheaf.map (homOfLE le_top).op).hom (globalSectionsIso.hom r) • (F.val section)`. Closed
by **`rfl`** (the functor's action = `restrictScalars(globalSectionsIso.hom)` ∘
`forgetToPresheafModuleCatObjObj`'s restrictScalars, unfolding definitionally). Independently
re-verified (review) with fresh `lake env lean` — genuine, not a stale-olean artifact.

### `modulesRestrictBasicOpen_smul_eq` (line ~740) — SOLVED, axiom-clean
Tile action `c • m` transports rfl-style through the two open-immersion `appIso` ring maps
(`(specBasicOpen g).ι.appIso`, `(basicOpenIsoSpecAway g).inv.appIso`) to `F.val`'s action on `W`.
Closed by **`rfl`**. The prover explicitly re-verified with a real `lake env lean` build per the
`keystone-tile-reconciliation-not-rfl` stale-olean warning; review re-confirmed (fresh build EXIT 0).

### `tile_section_comparison` (Sub-lemma B) — PARTIAL (reduced, not closed; NO sorry papered)
Proven tactic prefix:
```
rw [modulesSpecToSheaf_smul_eq F]
rw [show (algebraMap R (Localization.Away g) r) • x = _ from
      modulesSpecToSheaf_smul_eq (modulesRestrictBasicOpen g F) ⊤ _ x]
rw [modulesRestrictBasicOpen_smul_eq]
congr 1
simp only [Scheme.Opens.ι_appIso, StructureSheaf.globalSectionsIso_hom]
```
Residual (`case e_a`, verified via `lean_goal`):
```
(ringCatSheaf.map (homOfLE ⋯).op).hom (algebraMap R Γ(W,𝒪) r)
  = ((basicOpenIsoSpecAway g).inv.appIso ⊤).inv.hom
      (algebraMap R_g Γ(⊤,𝒪_{R_g}) (algebraMap R R_g r))
```
i.e. "sections over `D(g)` = the localization `R_g`, compatibly with `algebraMap`."
**Dead end (do NOT retry):** a single naive `rfl`/`simp` close of the *full* compat fails
(kernel-confirmed). Several `simp` variants were tried (`Scheme.Hom.comp_appIso` +
`specAwayToSpec_eq`; `Scheme.Opens.ι_appIso`; `ΓSpecIso_inv_naturality` + `toSpecΓ_appTop`) —
none closed it. The residual is genuine structure-sheaf naturality, not unfolding.

### `tile_section_localization` — BLOCKED (gated on Sub-lemma B); comment-only, no sorry.

## Subagent findings (full reports linked, not duplicated)
- **lean-auditor `iter043`** (`task_results/lean-auditor-iter043.md`): **0 must-fix.** Both
  `rfl` lemmas independently verified genuine + axiom-clean. 3 major (all advisory): two
  deprecated `CategoryTheory.Sheaf.val` (`.val.obj`) uses in the new lemmas' `show` ascriptions
  (will break when the alias is removed upstream — use `ObjectProperty.obj`); one comment
  over-claim ("PROVEN tactic prefix" for the never-compiled `tile_scalar_compat`). 4 minor
  (undocumented `rfl` fragility; a comment-vs-header tension on "does NOT commute definitionally";
  line-length lint).
- **lean-vs-blueprint-checker `qts`** (`task_results/lean-vs-blueprint-checker-qts.md`): **0
  must-fix, 0 Lean red flags** (17 decls checked). 3 major, all blueprint-side: the two new
  lemmas lack `\lean{}` pins (coverage debt); and the `lem:tile_section_comparison` sketch is now
  **inaccurate** — "~100–150 LOC" overstates the residual 3–5× (real residual = one ring
  identity, ~30–50 LOC) and the "genuinely non-definitional" claim is now imprecise (the scalar
  bridges ARE `rfl`).

## Key findings / patterns
- **`rfl` scalar bridges across global/local-ring section functors are real** when the open is
  kept in iterated-image form. Pattern: `modulesSpecToSheaf.obj F` action over `W` = `F.val`'s
  `Γ(W,𝒪)`-action with the `globalSectionsIso`-restricted scalar; tile action transports through
  the `appIso` ring maps. Both `rfl`. Always confirm with a fresh `lake env lean` (stale-olean trap).
- **Honest stop maintained:** mathlib-build no-sorry invariant held; the named targets were left
  absent (comment-documented) rather than papered, and the obstruction was decomposed precisely.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:tile_section_comparison`: added a
  `% NOTE (review iter-043): ...` flagging that the proof note's "~100–150 LOC" estimate and
  "NOT rfl / genuinely non-definitional" claim are now STALE (two rfl bridges landed; residual =
  one ring identity, ~30–50 LOC), with the explicit residual identity and closure routes, and a
  pointer for the planner to dispatch a writer before re-dispatch.

## Recommendations for next session
See `recommendations.md`. Top item: refine the `lem:tile_section_comparison` blueprint sketch
(blueprint-writer) + add blocks for the two new rfl sub-lemmas BEFORE re-dispatching the closer,
else a prover may build an unnecessary 100–150 LOC construction.
