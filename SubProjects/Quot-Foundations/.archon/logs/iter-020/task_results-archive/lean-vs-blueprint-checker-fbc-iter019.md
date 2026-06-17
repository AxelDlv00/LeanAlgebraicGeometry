# Lean ↔ Blueprint Check Report

## Slug
fbc-iter019

## Iteration
019

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (1723 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (2847 lines)

---

## Per-declaration

### `\lean{AlgebraicGeometry.pushforwardBaseChangeMap}` (def:pushforward_base_change_map)
- **Lean target exists**: yes (line 79)
- **Signature matches**: yes — `(Scheme.Modules.pullback g).obj ((pushforward f).obj F) ⟶ (pushforward f').obj ((Scheme.Modules.pullback g').obj F)`, adjoint mate construction matches prose description
- **Proof follows sketch**: yes — built as the `(g^*, g_*)`-adjunction transpose of the blueprint composite
- **notes**: none

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_stalkFunctor_map}` (lem:modules_isIso_iff_stalk)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` + forgetful reflection, matches blueprint
- **notes**: none

### `\lean{AlgebraicGeometry.Modules.isIso_of_isIso_app_of_isBasis}` (lem:modules_isIso_of_isBasis)
- **Lean target exists**: yes (line 128)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.Modules.isIso_iff_isIso_app_affineOpens}` (lem:modules_isIso_iff_affineOpens)
- **Lean target exists**: yes (line 164)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.globalSectionsIso_hom_comp_specMap_appTop}` (lem:globalSectionsIso_hom_comp_specMap_appTop)
- **Lean target exists**: yes (line 268)
- **Signature matches**: yes — `(StructureSheaf.globalSectionsIso ↑R).hom ≫ (Spec.map φ).appTop = φ ≫ (StructureSheaf.globalSectionsIso ↑R').hom`
- **Proof follows sketch**: yes — via `Scheme.ΓSpecIso_inv_naturality`
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardIso}` (lem:gammaPushforwardIso)
- **Lean target exists**: yes (line 288)
- **Signature matches**: yes
- **Proof follows sketch**: yes — element-free route (b), `restrictScalarsComp'App` × 2 + `eqToIso`
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardTildeIso}` (lem:gammaPushforwardTildeIso)
- **Lean target exists**: yes (line 313)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.gammaPushforwardIsoAt}` (lem:gammaPushforwardIsoAt)
- **Lean target exists**: yes (line 331)
- **Signature matches**: yes — sections over arbitrary open `U`
- **Proof follows sketch**: yes — identical construction to `gammaPushforwardIso` with `⊤` replaced by `U`
- **notes**: none

### `\lean{AlgebraicGeometry.tildeRestriction_isLocalizedModule}` (lem:tildeRestriction_isLocalizedModule)
- **Lean target exists**: yes (line 483)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.IsLocalizedModule.powers_restrictScalars}` (lem:powers_restrictScalars)
- **Lean target exists**: yes (line 455)
- **Signature matches**: yes
- **Proof follows sketch**: yes — three conditions checked directly
- **notes**: none

### `\lean{AlgebraicGeometry.fromTildeΓ_app_isIso_of_isLocalizedModule}` (lem:fromTildeGamma_app_isIso_of_localized)
- **Lean target exists**: yes (line 367)
- **Signature matches**: yes
- **Proof follows sketch**: yes — triangle identity + uniqueness of localized modules
- **notes**: none

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso_of_isLocalizedModule}` (lem:pushforward_spec_tilde_iso_conditional)
- **Lean target exists**: yes (line 431)
- **Signature matches**: yes
- **Proof follows sketch**: yes — basis-local criterion + counit iso + tilde of Γ-comparison
- **notes**: none

### `\lean{AlgebraicGeometry.pushforward_spec_tilde_iso}` (lem:pushforward_spec_tilde_iso)
- **Lean target exists**: yes (line 538)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `algebraize` + `gammaPushforwardIsoAt` naturality + transport chain
- **notes**: fully proved, axiom-clean; the former carrier-instance wall is resolved

### `\lean{AlgebraicGeometry.gammaPushforwardNatIso}` (lem:gammaPushforwardNatIso)
- **Lean target exists**: yes (line 667)
- **Signature matches**: yes
- **Proof follows sketch**: yes — pointwise `rfl`
- **notes**: none

### `\lean{AlgebraicGeometry.pullback_spec_tilde_iso}` (lem:pullback_spec_tilde_iso)
- **Lean target exists**: yes (line 689)
- **Signature matches**: yes
- **Proof follows sketch**: yes — uniqueness-of-left-adjoints via `conjugateIsoEquiv`
- **notes**: none

### `\lean{AlgebraicGeometry.pullback_fst_snd_specMap_tensor}` (lem:pullback_fst_snd_specMap_tensor)
- **Lean target exists**: yes (line 709)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `pullbackSpecIso_inv_fst` / `_inv_snd`
- **notes**: none

### `\lean{AlgebraicGeometry.pullbackIsoEquivalenceOfIso}` (lem:pullbackIsoEquivalenceOfIso)
- **Lean target exists**: yes (line 753)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `pullbackComp` + `pullbackId` coherences
- **notes**: none

### `\lean{AlgebraicGeometry.pullback_isEquivalence_of_iso}` (lem:pullback_isEquivalence_of_iso)
- **Lean target exists**: yes (line 762, as `instance`)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-liner from `pullbackIsoEquivalenceOfIso`
- **notes**: Lean declares as `instance`, blueprint as `lemma` — consistent

### `\lean{AlgebraicGeometry.base_change_mate_domain_read}` (lem:base_change_mate_domain_read)
- **Lean target exists**: yes (line 737)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read}` (lem:base_change_mate_codomain_read)
- **Lean target exists**: yes (line 773)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `pullback_fst_snd_specMap_tensor` + two dictionaries
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_codomain_read_legs}` (lem:base_change_mate_codomain_read_legs)
- **Lean target exists**: yes (line 1210)
- **Signature matches**: yes — universal quantification over free legs `g'`, `f'` with hypothesis `hfst`/`hsnd`
- **Proof follows sketch**: yes — same body as `base_change_mate_codomain_read`
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_regroupEquiv}` (lem:base_change_mate_regroupEquiv)
- **Lean target exists**: yes (line 856)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `comm ≫ cancelBaseChange ≫ comm` with `A`-action diamond resolved by `eT`; fully proved route (a)
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_inner_value}` (def:base_change_mate_inner_value)
- **Lean target exists**: yes (line 1102)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_unit_value}` (lem:base_change_mate_unit_value)
- **Lean target exists**: yes (line 987)
- **Signature matches**: yes — conjugate-unit coherence identity
- **Proof follows sketch**: yes — `unit_conjugateEquiv_symm` + move 1–4 chain; proved with `set_option maxHeartbeats 4000000`
- **notes**: none

### `\lean{AlgebraicGeometry.pullbackPushforward_unit_comp}` (lem:pullbackPushforward_unit_comp)
- **Lean target exists**: yes (line 1144)
- **Signature matches**: yes
- **Proof follows sketch**: yes — `unit_conjugateEquiv` + `conjugateEquiv_pullbackComp_inv` + `comp_unit_app`
- **notes**: none

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (lem:gammaMap_pushforwardComp_hom_eq_id)
- **Lean target exists**: yes (line 1174)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: declared `private lemma`; blueprint pins it with full public name `AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id` which is not the accessible name (minor naming discrepancy)

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (lem:gammaMap_pushforwardComp_inv_eq_id)
- **Lean target exists**: yes (line 1182)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: same private/public naming issue as above

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (lem:gammaMap_pushforwardCongr_hom)
- **Lean target exists**: yes (line 1193)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: same private/public naming issue as above

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_unitExpand}` (lem:base_change_mate_fstar_reindex_legs_unitExpand)
- **Lean target exists**: yes (line 1273)
- **Signature matches**: yes
- **Proof follows sketch**: yes — inversion of `pullbackPushforward_unit_comp` by post-composing `pullbackComp.hom`
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_gammaDistribute}` (lem:base_change_mate_fstar_reindex_legs_gammaDistribute)
- **Lean target exists**: yes (line 1304)
- **Signature matches**: yes
- **Proof follows sketch**: yes — pure functoriality
- **notes**: none

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_eCancel}` (lem:base_change_mate_fstar_reindex_legs_eCancel)
- **Lean target exists**: **no** — declaration absent from the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: blueprint has no `\leanok` on this block; it is a planned atomic link (step iii-3) for `base_change_mate_fstar_reindex_legs`, not yet formalized

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_affineUnit}` (lem:base_change_mate_fstar_reindex_legs_affineUnit)
- **Lean target exists**: **no** — declaration absent from the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: blueprint has no `\leanok`; planned step iii-4

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs_innerMatch}` (lem:base_change_mate_fstar_reindex_legs_innerMatch)
- **Lean target exists**: **no** — declaration absent from the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: blueprint has no `\leanok`; planned step iii-5

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex_legs}` (lem:base_change_mate_fstar_reindex_legs)
- **Lean target exists**: yes (line 1333)
- **Signature matches**: yes — universal quantification over free legs, conclusion `= base_change_mate_inner_value ψ φ M`
- **Proof follows sketch**: **no** — proof body ends with `sorry` at line 1421 (step iii, the "mate-unwinding crux")
- **notes**: Steps (i) (`subst hfst/hsnd`) and (ii) (Γ-collapse via `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) are executed; the BLOCKER is that after `subst`, the locked leg literal `(pullbackSpecIso …).hom ≫ Spec.map (CommRingCat.ofHom …)` does not unify with the metavariable composite pattern `?a ≫ ?b`, preventing `rw [unitExpand]`/`rw [gammaDistribute …]` from matching. The three atomic-link lemmas (iii-3)–(iii-5) needed to complete step (iii) are designed but not yet formalized.

### `\lean{AlgebraicGeometry.base_change_mate_fstar_reindex}` (lem:base_change_mate_fstar_reindex)
- **Lean target exists**: yes (line 1435)
- **Signature matches**: yes
- **Proof follows sketch**: **no** — proof reduces to `exact base_change_mate_fstar_reindex_legs … ` which carries sorry transitively
- **notes**: once `base_change_mate_fstar_reindex_legs` is proved, this closes by `exact`

### `\lean{AlgebraicGeometry.base_change_mate_gstar_transpose}` (lem:base_change_mate_gstar_transpose)
- **Lean target exists**: yes (line 1490)
- **Signature matches**: yes — `(base_change_mate_domain_read ψ φ M).inv ≫ Γ(g^*(inner) ≫ ε_g) ≫ (base_change_mate_codomain_read ψ φ M).hom = (base_change_mate_regroupEquiv ψ φ M).inv`
- **Proof follows sketch**: **no** — proof starts with `rw [Functor.map_comp]` (splitting `Γ(g^*(inner) ≫ ε_g)`) then ends with `sorry` at line 1525
- **notes**: the genuine crux is the pullback-dictionary coherence: conjugating `Γ(g^*(inner)) ≫ Γ(ε_g)` by `Θ_src`/`Θ_tgt` via `pullback_spec_tilde_iso ψ` (uniqueness-of-left-adjoints, abstract) to land on `extendScalars ψ ∘ ρ`; the abstract adjoint-mate calculus (composed-adjunction counit-triangle identity) is documented but not yet implemented

### `\lean{AlgebraicGeometry.base_change_mate_section_identity}` (lem:base_change_mate_section_identity)
- **Lean target exists**: yes (line 1550)
- **Signature matches**: yes
- **Proof follows sketch**: **no** — calls `base_change_mate_gstar_transpose` (sorry), transitively incomplete
- **notes**: the `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit]` reduction is done; remainder is Seam 3

### `\lean{AlgebraicGeometry.base_change_mate_generator_trace}` (lem:base_change_mate_generator_trace)
- **Lean target exists**: yes (line 1579)
- **Signature matches**: yes
- **Proof follows sketch**: **no** — transitively sorry via `base_change_mate_section_identity`
- **notes**: once section_identity is proved, this closes in one line by `rw [base_change_mate_section_identity]; infer_instance`

### `\lean{AlgebraicGeometry.pushforward_base_change_mate_cancelBaseChange}` (lem:pushforward_base_change_mate_cancelBaseChange)
- **Lean target exists**: yes (line 1616)
- **Signature matches**: yes — `IsIso (Γ(pushforwardBaseChangeMap … (tilde M)))`
- **Proof follows sketch**: **no** — transitively sorry via `base_change_mate_generator_trace`
- **notes**: conjugation shell is correctly assembled; the IsIso inference from the conjugate will close once generator_trace is proved

### `\lean{AlgebraicGeometry.base_change_map_affine_local}` (lem:base_change_map_affine_local)
- **Lean target exists**: yes (line 1655)
- **Signature matches**: yes
- **Proof follows sketch**: yes — one-liner via `Modules.isIso_iff_isIso_app_affineOpens`
- **notes**: none

### `\lean{AlgebraicGeometry.affineBaseChange_pushforward_iso}` (lem:affine_base_change_pushforward)
- **Lean target exists**: yes (line 1667)
- **Signature matches**: yes
- **Proof follows sketch**: **no** — proof applies `base_change_map_affine_local` then ends with `sorry` at line 1698
- **notes**: the remaining obligation is the affine reduction — restricting the arbitrary square over each affine open `U ⊆ S'` and identifying `(pushforwardBaseChangeMap …).app U` with the affine–affine base-change map of the restricted square; this is the "restriction-compatibility of pushforwardBaseChangeMap" (multi-hundred-LOC build, Mathlib-absent)

### `\lean{AlgebraicGeometry.flatBaseChange_pushforward_isIso}` (thm:flat_base_change_pushforward)
- **Lean target exists**: yes (line 1707)
- **Signature matches**: yes — `[Flat g] [QuasiCompact f] [QuasiSeparated f] [F.IsQuasicoherent]`
- **Proof follows sketch**: **no** — body is entirely `sorry` (line 1720)
- **notes**: proof strategy documented (sheaf-condition equalizer + flatness + Mayer–Vietoris induction); needs Čech/affine-cover infrastructure for `SheafOfModules`

---

## Red flags

### Placeholder / suspect bodies

- `base_change_mate_fstar_reindex_legs` at line 1421: `sorry` on the step-(iii) mate-unwinding crux. Blueprint (lem:base_change_mate_fstar_reindex_legs) provides a full 5-link proof sketch; steps (i) and (ii) are executed but step (iii) is `sorry`. This is the primary blocking sorry for the whole section-level computation chain.

- `base_change_mate_gstar_transpose` at line 1525: `sorry` on the Seam-3 pullback-dictionary coherence. Blueprint (lem:base_change_mate_gstar_transpose) provides a full proof sketch (counit factorization + conjugation via composed-adjunction counit-triangle identity). Partially executed: `rw [Functor.map_comp]` done.

- `affineBaseChange_pushforward_iso` at line 1698: `sorry` on the affine reduction step (restriction-compatibility of `pushforwardBaseChangeMap`). Blueprint proof describes the required naturality argument. This is a multi-hundred-LOC build.

- `flatBaseChange_pushforward_isIso` at line 1720: entire proof body is `sorry`. Blueprint (thm:flat_base_change_pushforward) gives a full proof sketch (sheaf-condition equalizer + Mayer–Vietoris). Needs Čech/cover infrastructure not yet built.

**Transitively sorry** (will close once the above are resolved):
- `base_change_mate_fstar_reindex` (calls `base_change_mate_fstar_reindex_legs`)
- `base_change_mate_section_identity` (calls `base_change_mate_gstar_transpose`)
- `base_change_mate_generator_trace` (calls `base_change_mate_section_identity`)
- `pushforward_base_change_mate_cancelBaseChange` (calls `base_change_mate_generator_trace`)

### Excuse-comments
None. All sorry-adjacent comments are honest technical blocker descriptions (elaboration pathology, missing Mathlib infrastructure, Mathlib-absent mate-unwinding), not "wrong but will fix" excuses.

### Axioms / Classical.choice on non-trivial claims
None found.

---

## Unreferenced declarations (informational)

All substantive declarations in the Lean file correspond to blueprint `\lean{...}` blocks. The three `private lemma` declarations (`gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`) are referenced by the blueprint with public qualified names; within-file use is unaffected, but the blueprint-pinned names are not externally accessible (Lean `private` name mangling). This is a cosmetic issue only.

---

## Blueprint adequacy for this file

- **Coverage**: 38/38 substantive Lean declarations have a corresponding `\lean{...}` block (31 fully proved, 8 with sorry, 3 unformalized atomic links with no `\leanok`). Coverage is complete.
- **Proof-sketch depth**: **adequate**. The blueprint proof sketches are unusually detailed — the five-link decomposition of Seam 2, the counit-triangle-identity argument of Seam 3, and the Mayer–Vietoris induction for the global theorem are all spelled out to the level needed for a prover. The three atomic-link lemmas (iii-3, iii-4, iii-5) that are not yet formalized have sufficient prose description in the blueprint to guide their formalization.
- **Hint precision**: **precise**. The blueprint `\lean{...}` pins are correct for all formalized declarations. For the three unformalized atomic-link lemmas the `\lean{}` names are stated and the signatures described accurately in LEAN SIGNATURE comments.
- **Generality**: **matches need**. The blueprint correctly scopes each lemma (ring maps, modules, arbitrary opens) and the Lean signatures match.
- **Recommended chapter-side actions**:
  - Add `\leanok` markers to the statement blocks of the three atomic-link lemmas (iii-3, iii-4, iii-5) once their Lean counterparts are formalized.
  - The proof block of `lem:base_change_mate_fstar_reindex_legs` could benefit from an additional NOTE acknowledging that the step-(iii) BLOCKER (literal-leg locking after `subst`) requires either (a) a `g'`-parametrised variant applied before `subst` or (b) a term-mode telescope that avoids `rw` on the locked leg entirely. The current prose describes the approach but not this specific obstacle.
  - The three `private lemma` declarations in Lean should be made non-private (or their blueprint `\lean{}` pins updated to use the mangled name) to avoid the discrepancy.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `sorry` at line 1421 in `base_change_mate_fstar_reindex_legs` (step iii BLOCKER) | **must-fix-this-iter** |
| `sorry` at line 1525 in `base_change_mate_gstar_transpose` (Seam-3 crux) | **must-fix-this-iter** |
| `sorry` at line 1698 in `affineBaseChange_pushforward_iso` (affine reduction) | **must-fix-this-iter** |
| `sorry` at line 1720 in `flatBaseChange_pushforward_isIso` (main theorem) | **must-fix-this-iter** |
| Blueprint declares `base_change_mate_fstar_reindex_legs_eCancel/affineUnit/innerMatch` with no Lean counterpart | **major** (planned, no `\leanok` in blueprint — consistent, but blocking step-iii assembly) |
| `private lemma` declarations pinned in blueprint with public names | **minor** |

**Overall verdict**: The file's core infrastructure (tilde dictionaries, basis-local iso criterion, Γ-pushforward isos, regrouping equivalence, Seam-1) is fully proved and axiom-clean; signatures match the blueprint throughout. The blocking items are four `sorry`-bearing proofs — the Seam-2 step-iii crux, the Seam-3 pullback-dictionary coherence, the affine-reduction restriction-compatibility, and the main flat-base-change theorem — all of which downstream work depends on. The blueprint chapter is sufficiently detailed to guide their formalization; no blueprint adequacy failures.
