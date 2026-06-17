# Lean ↔ Blueprint Check Report

## Slug
cotangent-grpobj-iter142

## Iteration
142

## Files audited
- Lean: `AlgebraicJacobian/Cotangent/GrpObj.lean` (851 lines, 14 top-level decls — 2 private)
- Blueprint (substantive): `blueprint/src/chapters/RigidityKbar.tex` (1349 lines)
- Blueprint (pointer): `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` (82 lines)

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity}` (chapter: `lem:GrpObj_cotangentSpace`, L92–122)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:162`).
- **Signature matches**: yes — chapter stub L100–102 verbatim matches Lean L162–165 (free `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` binder + `[IsProper G.hom]` + `[GeometricallyIrreducible G.hom]` → `ModuleCat k`).
- **Proof follows sketch**: yes — body is the iter-131 `Classical.choose`-chain (`let h := smooth_locally_free_omega …; let U; let V; let e; let hxV; …; ψV; (extendScalars ψV.hom).obj (ModuleCat.of … Ω[…])`), exactly the construction described in the chapter proof L115–119 and the "Iter-131 `Classical.choose`-chain body shape" footer L1319–1323.
- **notes**: Body fully closed (no `sorry`). Outer head symbol is `(ModuleCat.extendScalars _).obj (ModuleCat.of _ Ω[_ ⁄ _])`, matching the structural-shape promise made in the chapter.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_eq_extendScalars}` (chapter: `lem:GrpObj_cotangentSpace_extendScalars_witness`, L124–160)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:211`).
- **Signature matches**: yes — chapter stub L134–147 reproduces the Lean type verbatim, including the `letI : Algebra ↥Γ(…) ↥Γ(…) := (appLE …).hom.toAlgebra` instance under the existential.
- **Proof follows sketch**: yes — proof L224–232 reproduces the `Classical.choose`-chain on `smooth_locally_free_omega` (matches the prose's "reproduce the body's `Classical.choose`-chain on `smooth_locally_free_omega`'s existential" at chapter L159), closes via `rfl` after the `Subsingleton.elim` on points of `Spec k`.
- **notes**: Fully closed (no `sorry`).

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_iso_localRingCotangent}` (chapter: `lem:GrpObj_cotangent_bridge`, L162–216)
- **Lean target exists**: no — declaration not in this file (none found in `Cotangent/GrpObj.lean`). 
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: The chapter explicitly marks the block `\notready` (L183) and the iter-131 strategy-critic footer at the end of the rank-lemma proof (L279) demotes it to "vestigial on the live path under Replacement (B)". The pointer chapter `AlgebraicJacobian_Cotangent_GrpObj.tex` correctly omits this declaration from the file's declaration list. **Not in this file's scope** — acceptable.

### `\lean{AlgebraicGeometry.GrpObj.cotangentSpaceAtIdentity_finrank_eq}` (chapter: `lem:GrpObj_lieAlgebra_finrank`, L218–280)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:257`).
- **Signature matches**: yes — chapter stub L225–228 verbatim matches Lean L257–260.
- **Proof follows sketch**: yes — Lean proof L261–295 implements exactly Steps 1+2 (live closure path) of the chapter proof L244–265: re-extract the chart witnesses by replaying the `Classical.choose`-chain, extract `hfree`/`hrank` from the existential, build `algGV`/`algGVk`, `change` the goal to `Module.finrank k (TensorProduct …)`, then `rw [Module.finrank_baseChange]; exact Module.finrank_eq_of_rank_eq hrank`. Steps 3 (alternative canonical route) and 4 (dualisation) are correctly documented as not on the live path.
- **notes**: Fully closed (no `sorry`). The chapter's Mathlib-name summary at L277 is verified against actual lemma uses.

### `\lean{AlgebraicGeometry.GrpObj.shearMulRight}` (chapter: `lem:GrpObj_shearMulRight`, L282–329)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:350`).
- **Signature matches**: yes — chapter stub L295–298 (`def shearMulRight {C : Type*} [Category C] [CartesianMonoidalCategory C] (G : C) [GrpObj G] : G ⊗ G ≅ G ⊗ G`, `hom := lift (fst G G) μ`, `inv := lift (fst G G) (lift (fst G G ≫ ι) (snd G G) ≫ μ)`) verbatim matches Lean L350–352 plus the `@[simps]` attribute.
- **Proof follows sketch**: yes — both `hom_inv_id` and `inv_hom_id` use `CartesianMonoidalCategory.hom_ext`; second-coordinate goals close via `MonObj.lift_lift_assoc`, `GrpObj.lift_comp_inv_left/right`, `MonObj.lift_comp_one_left`. Exactly the calculus described at chapter L321–328.
- **notes**: Fully closed (no `sorry`). Companion `@[simps]`-spawned (manually defined here as `@[reassoc (attr := simp)]`) helpers `shearMulRight_hom_fst` (L387) and `shearMulRight_hom_snd` (L392) are mentioned in chapter prose L313–315 and 328; coverage is adequate.

### `\lean{AlgebraicGeometry.GrpObj.mulRight_globalises_cotangent}` (chapter: `lem:GrpObj_mulRight_globalises`, L331–425)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:837`).
- **Signature matches**: yes — chapter stub L347–354 matches Lean L837–847 (`relativeDifferentialsPresheaf G.hom ≅ (PresheafOfModules.pullback (φ_str G)).obj ((PresheafOfModules.pullback (φ_η G)).obj (relativeDifferentialsPresheaf G.hom))`); chapter's `φ_str G` and `φ_η G` correspond exactly to `Scheme.Hom.toRingCatSheafHom G.hom` and `Scheme.Hom.toRingCatSheafHom η[G].left` respectively (per `analogies/phi-compatibility-morphisms.md` adopted iter-135).
- **Proof follows sketch**: partial — Lean body is `sorry` at L848 (per directive: honest open scaffold, do not flag). Chapter proof (Step 1 / Step 2 / Step 3 / Compose) at L407–420 is detailed and would guide a compose-the-three-pieces formalization. Lean docstring L808–836 mirrors the chapter's outline accurately.
- **notes**: Honest open scaffold per iter-142 directive. The `\leanok` at chapter L406 on this proof block is a `sync_leanok` mis-mark — see Red flags below.

### `\lean{AlgebraicGeometry.GrpObj.schemeHomRingCompatibility}` (chapter: `def:GrpObj_schemeHomRingCompatibility`, L427–437)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:424`).
- **Signature matches**: yes — chapter's "$f_{\mathrm{top}}^{-1}\,\mathcal O_Z \to \mathcal O_Y$ … image of $f^\sharp$ under the symmetric direction of the presheaf-pullback / pushforward adjunction" matches Lean's `((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm f.c` precisely.
- **Proof follows sketch**: N/A (definition; both sides expose the same adjunction-transpose recipe).
- **notes**: Fully closed (no `sorry`). The chapter's remark L439–443 correctly distinguishes this from the `PresheafOfModules.pullback`-compatible `Scheme.Hom.toRingCatSheafHom` shape, mirroring the Lean docstring's "**Note**: this is **not** the φ for `PresheafOfModules.pullback`…" caveat at L420–423.

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two}` (chapter: `lem:GrpObj_omega_basechange_proj`, L445–1082)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:701`).
- **Signature matches**: yes — chapter prose L490–494 (`Ω_{(G ×_k G)/G} ≅ pr_2^* Ω_{G/k}` on `G ×_k G`, viewing `G ×_k G` as a `G`-scheme via `pr_1`) matches Lean L701–708 (`Scheme.relativeDifferentialsPresheaf (fst G G).left ≅ (PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom)`). Chapter stub L456–461 is fragmentary (`.⋯`) but the prose pins the type unambiguously. Extra `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` / `[IsProper G.hom]` / `[GeometricallyIrreducible G.hom]` binders in the Lean signature (L703–704) are unused but harmless.
- **Proof follows sketch**: partial — Lean body is `(asIso (basechange_along_proj_two_inv G)).symm` after `letI : IsIso (basechange_along_proj_two_inv G) := isIso_of_app_iso_module (basechange_along_proj_two_inv G) (fun _ => sorry)` at L719–721 (per directive: honest open scaffold, do not flag). Chapter has an extensive iter-138/139/140/141 NOTE-block layered narrative (L499–1074) describing Route (b'2) closure recipe, the `pullback`-opacity blocker, and the three concrete sub-sorries — fully consistent with the Lean docstring at L465–525 and the residual `(fun _ => sorry)` shape.
- **notes**: Honest open scaffold per iter-142 directive. The `\leanok` at chapter L524 on this proof block is a `sync_leanok` mis-mark (carry-over per directive) — see Red flags below. Chapter proof block carries multiple NOTE blocks (iter-138, iter-139, iter-140, iter-141) that exhaustively document the closure path and remaining gaps; chapter prose is exceptionally well-aligned with Lean state.

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv_derivation}` (chapter: `lem:GrpObj_omega_basechange_proj_inv_derivation`, L1084–1167)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:573`).
- **Signature matches**: yes — chapter stub L1092–1098 verbatim matches Lean L573–579 (`Derivation'` target on `(pushforward ψ).obj LHS` over `((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat G.hom.base).homEquiv _ _).symm G.hom.c`).
- **Proof follows sketch**: partial — additive (`d_add`) and Leibniz (`d_mul`) laws closed using the `have h := RingHom.map_add/mul; change …; rw [h]; exact ModuleCat.Derivation.d_add/mul …` four-step pattern exactly as described in the chapter's iter-138 negative-lesson NOTE (L594–611). `d_app` carries an honest `sorry` at L637 (per directive: do not flag). `d_map` is now closed (chapter L1162–1165 cites this as an iter-140 target; iter-142 closed it via the `change/NatTrans.naturality_apply/relativeDifferentials'_map_d.symm` three-step chase at Lean L638–674, matching the chapter's iter-141 three-step ALIGN_WITH_MATHLIB chase recipe at L769–781).
- **notes**: One honest open `sorry` (d_app at L637). The `\leanok` at chapter L1152 on this proof block is a `sync_leanok` mis-mark (carry-over per directive) — see Red flags below.

### `\lean{AlgebraicGeometry.GrpObj.basechange_along_proj_two_inv}` (chapter: `lem:GrpObj_omega_basechange_proj_inv`, L1169–1237)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:685`).
- **Signature matches**: yes — chapter stub L1180–1185 (`(PresheafOfModules.pullback (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom).obj (Scheme.relativeDifferentialsPresheaf G.hom) ⟶ Scheme.relativeDifferentialsPresheaf (fst G G).left`) verbatim matches Lean L685–690.
- **Proof follows sketch**: yes — body L691–699 is the adjunction-transpose-of-`(isUniversal' φG).desc (…inv_derivation…)` construction exactly described in chapter proof L1222–1227.
- **notes**: Sorry-free as a *definition* (per chapter prose L1230–1231); the iso property is the load-bearing sub-sorry tracked on the parent block. `\leanok` at L1222 is correctly placed (Lean is sorry-free here).

### `\lean{AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_restrict_along_identity_section}` (chapter: `lem:GrpObj_omega_restrict_to_identity_section`, L1239–1285)
- **Lean target exists**: yes (`Cotangent/GrpObj.lean:741`).
- **Signature matches**: yes — chapter stub L1246–1255 (with `(φ_section G)`, `(φ_pr_two G)`, `(φ_str G)`, `(φ_η G)`) corresponds to Lean L741–756 (`Scheme.Hom.toRingCatSheafHom (lift (𝟙 G) (toUnit G ≫ η[G])).left`, `… (snd G G).left`, `… G.hom`, `… (CommaMorphism.left η[G])`). Extra `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` / `[IsProper G.hom]` / `[GeometricallyIrreducible G.hom]` binders (L743–744) are unused but harmless.
- **Proof follows sketch**: yes — Lean proof L757–784 uses `PresheafOfModules.pullbackComp` on both sides + `eqToIso` via the helper `section_snd_eq_identity_struct`, matching the chapter proof L1284 (which cites `PresheafOfModules.pullbackComp` applied to the composition identity `pr_2 ∘ s = η_G ∘ π_G`).
- **notes**: Fully closed (no `sorry`). `\leanok` at L1283 is correct.

## Red flags

### Placeholder / suspect bodies
None to flag beyond the three honest open scaffolds the iter-142 directive explicitly tells me NOT to re-flag:
- `Cotangent/GrpObj.lean:637` — d_app body (inside `basechange_along_proj_two_inv_derivation`).
- `Cotangent/GrpObj.lean:720` — `(fun _ => sorry)` argument to `isIso_of_app_iso_module` (inside `relativeDifferentialsPresheaf_basechange_along_proj_two`).
- `Cotangent/GrpObj.lean:848` — main body of `mulRight_globalises_cotangent`.

All three are documented as concrete next-iter targets in the surrounding Lean docstrings and the chapter's iter-138/139/140/141/142 NOTE-block layered narrative; none is a "fake placeholder" pretending to be a real proof.

### `\leanok` mis-marks on proof blocks (`sync_leanok` deterministic-phase concerns)

These are `sync_leanok` responsibility per CLAUDE.md, NOT for any agent to edit directly. Flagging bidirectionally as the directive requests:

- **`RigidityKbar.tex:406`** (proof block of `lem:GrpObj_mulRight_globalises`) carries `\leanok` while Lean target `mulRight_globalises_cotangent` body at `Cotangent/GrpObj.lean:848` is `sorry`. (This is the third of the directive's "three carry-over mis-mark candidates" — only two were enumerated in the directive bullets; this is the implicit third.)
- **`RigidityKbar.tex:524`** (proof block of `lem:GrpObj_omega_basechange_proj`) carries `\leanok` while Lean target `relativeDifferentialsPresheaf_basechange_along_proj_two` retains `(fun _ => sorry)` at `Cotangent/GrpObj.lean:720`. (Per directive — confirmed.)
- **`RigidityKbar.tex:1152`** (proof block of `lem:GrpObj_omega_basechange_proj_inv_derivation`) carries `\leanok` while Lean target `basechange_along_proj_two_inv_derivation` retains the `d_app sorry` at `Cotangent/GrpObj.lean:637`. (Per directive — confirmed.)

All three are likely `sync_leanok` mis-handles of the `letI … := sorry` / `(fun _ => sorry)` term-mode `sorry` placements (the iter-139 NOTE at `RigidityKbar.tex:499–512` explicitly flags this concern as awaiting a `doctor`-skill consult). Iter-142 prover's d_map closure does NOT shift the verdict on these three blocks — d_map was the *fourth* sub-sorry, distinct from the three remaining.

### Excuse-comments
None. All Lean docstrings and inline comments describe the structural sub-tasks in concrete terms with citations to the analogist files and chapter NOTE-blocks; no "this is wrong but works for now" patterns.

### Axioms / Classical.choice on non-trivial claims
None. `Classical.choose` is used inside `cotangentSpaceAtIdentity` (L175–181) and `cotangentSpaceAtIdentity_finrank_eq` (L264–276) and `cotangentSpaceAtIdentity_eq_extendScalars` (L226–227) to unpack the existential output of `Scheme.smooth_locally_free_omega` — this is the project's authorized Replacement (B) extraction pattern documented in the chapter's "Iter-131 `Classical.choose`-chain body shape" footer (L1319–1323) and the Lean docstrings L138–144.

## Unreferenced declarations (informational)

- `Cotangent/GrpObj.lean:387` `shearMulRight_hom_fst` — `@[reassoc (attr := simp)]` companion of `shearMulRight`. Discussed in chapter prose L313–315 + 328 and L33 of the pointer chapter; helper-only, no dedicated `\lean{...}` block needed.
- `Cotangent/GrpObj.lean:392` `shearMulRight_hom_snd` — ditto.
- `Cotangent/GrpObj.lean:458` `section_snd_eq_identity_struct` — `private` helper for `relativeDifferentialsPresheaf_restrict_along_identity_section`. Explicitly discussed in the chapter iter-136 review NOTE at L1264–1268 ("new private helper … ~5 LOC; captures the categorical identity"). Helper-only — adequate.
- `Cotangent/GrpObj.lean:544` `isIso_of_app_iso_module` — `private` iso-reflection bridge for `PresheafOfModules` morphisms. Extensively discussed in the chapter's iter-139 Route (b'2) NOTE block at L959–984 ("The 5-line iso-reflection bridge … placed in `Cotangent/GrpObj.lean` adjacent to `basechange_along_proj_two_inv`") and the iter-140 update at L1012–1014 ("Item (1), the iso-reflection bridge `isIso_of_app_iso_module`, is closed in `AlgebraicJacobian/Cotangent/GrpObj.lean:544–550`"). Helper-only with upstream-PR-candidate framing — adequate.

No substantive Lean declarations lack chapter coverage.

## Blueprint adequacy for this file

- **Coverage**: 11/11 chapter `\lean{…}` blocks for this file map to actual Lean declarations (one — `cotangentSpaceAtIdentity_iso_localRingCotangent` — points to a Lean target that does not exist yet, but the chapter explicitly marks the block `\notready` and the pointer chapter correctly omits it from the file's declaration list). Conversely, all 12 substantive Lean declarations either have a `\lean{…}` block (8 of them) or are explicitly-helper-only declarations discussed in chapter NOTE blocks (4 of them: `shearMulRight_hom_fst/snd`, `section_snd_eq_identity_struct`, `isIso_of_app_iso_module`). The pointer chapter at `AlgebraicJacobian_Cotangent_GrpObj.tex` lists 9 of the 12 substantive declarations — the four `simps`/`private` helpers are appropriately not listed.
- **Proof-sketch depth**: **adequate** (in fact, exceptionally so for `lem:GrpObj_omega_basechange_proj`, `lem:GrpObj_omega_basechange_proj_inv_derivation`, and `lem:GrpObj_mulRight_globalises`). The chapter carries 5+ layered iter-NOTE blocks (iter-135 → iter-141) explaining route selection, the `pullback`-opacity blocker, the 5-step recipe, the d_app / d_map closure recipes including the iter-141 ALIGN_WITH_MATHLIB three-step chase used by iter-142's prover to close d_map. A prover walking into this chapter cold could formalize the closed declarations from prose alone, and could close d_app / IsIso from the chapter's recipe text alone (d_map already closed iter-142). The chapter's "honest pile cost" framing (L1334) and per-piece LOC budgets are consistent with the Lean state.
- **Hint precision**: **precise**. Every `\lean{…}` block names the full namespace-qualified Lean declaration; the chapter explicitly distinguishes `schemeHomRingCompatibility` from `Scheme.Hom.toRingCatSheafHom` (`rem:GrpObj_schemeHomRingCompatibility_vs_toRingCatSheafHom` at L439–443), exactly the distinction the Lean docstring at L420–423 also makes. The Mathlib predicate `SmoothOfRelativeDimension n G.hom` is pinned in every chapter stub matching the Lean signature.
- **Generality**: **matches need**. The chapter's "iter-127 over-k commitment" framing (L14) and `shearMulRight`'s generality over arbitrary Cartesian monoidal categories (L295–298 stub) align with the Lean's free `{C : Type*} [Category C] [CartesianMonoidalCategory C]` binder pattern. No parallel API has been written to compensate for chapter under-specification.
- **Recommended chapter-side actions**: none from this checker. The three `\leanok` mis-marks are `sync_leanok` deterministic-phase concerns explicitly out of scope for any agent's manual edit per CLAUDE.md; they will resolve once `sync_leanok` is taught to recognize term-mode `sorry` patterns (`letI … := sorry` and `(fun _ => sorry)` lambda arguments).

## Severity summary

- **must-fix-this-iter**: none. All `sorry`s are honest open scaffolds per the directive; chapter signatures match Lean verbatim; no excuse-comments; no unauthorized axioms; chapter is precisely-hinted and proof-detailed.
- **major**: none. The three `\leanok` mis-marks are formally `sync_leanok` deterministic-phase concerns, not agent-editable findings.
- **minor**:
  - Lean signatures for `relativeDifferentialsPresheaf_basechange_along_proj_two` (L701), `relativeDifferentialsPresheaf_restrict_along_identity_section` (L741), and `mulRight_globalises_cotangent` (L837) carry unused `{n : ℕ} [SmoothOfRelativeDimension n G.hom]` / `[IsProper G.hom]` / `[GeometricallyIrreducible G.hom]` binders. Harmless (these instances are present at every call site anyway via the parent `cotangentSpaceAtIdentity` consumer chain), but technically over-specified. Could be trimmed in a future refactor pass without affecting downstream consumers.
  - Some inline LOC citations in the chapter NOTE blocks reference stale line numbers (e.g. iter-138 NOTE cites `Cotangent/GrpObj.lean:581/585/624` but the current locations after intervening edits are L637/L643/L720). The chapter explicitly self-corrects in subsequent iter-NOTE updates (iter-140 update at L1010–1020, iter-141 update at L513–523) — bookkeeping drift only, no semantic issue.

## Overall verdict
The Lean follows the blueprint faithfully and the blueprint provides exceptionally detailed guidance for this file; the only outstanding concerns are three `sync_leanok` mis-marks (out of agent scope) and three honest open scaffolds that the directive itself excludes from re-reporting.
