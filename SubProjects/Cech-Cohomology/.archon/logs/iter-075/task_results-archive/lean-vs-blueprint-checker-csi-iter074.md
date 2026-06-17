# Lean ↔ Blueprint Check Report

## Slug
csi-iter074

## Iteration
074

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.sectionCechAugV}` (chapter: `def:sectionCechAugV`, line 8952)
- **Lean target exists**: yes (line 42)
- **Signature matches**: yes — type is `Γ(V, F) ⟶ (sectionCechComplexV 𝒰 F V).X 0`, i.e. the restriction-product map from sections-at-V to the degree-0 term of the concrete section Čech complex; matches blueprint's `ε_can : Γ(V,F) → ∏_i Γ(U_i ∩ V, F)`.
- **Proof follows sketch**: N/A (definition); body is `GV(Ψ(cechAugmentation)) ≫ (coreIso_objIso 0 V).hom`, exactly what the blueprint prescribes.
- **notes**: No free parameter; the construction is canonical, matching the blueprint's explicit note ("It carries no free parameter").

### `\lean{AlgebraicGeometry.sectionCechAugV_comp_d}` (chapter: `lem:sectionCechAugV_comp_d`, line 8976)
- **Lean target exists**: yes (line 57)
- **Signature matches**: yes — `sectionCechAugV 𝒰 F V ≫ (sectionCechComplexV 𝒰 F V).d 0 1 = 0`; matches blueprint's `ε_can · d^0 = 0`.
- **Proof follows sketch**: yes — proof conjugates through `coreIso_comm`, reads off the functorial-image-of-zero argument via `cechAugmentation_comp_d`, exactly as blueprint says.
- **notes**: `maxHeartbeats` raised to 1600000 with inline comment explaining the whnf cost; not a red flag.

### `\lean{AlgebraicGeometry.sectionCechAugV_π}` (chapter: `lem:sectionCechAugV_π`, line 9002)
- **Lean target exists**: yes (line 572)
- **Signature matches**: yes — `sectionCechAugV 𝒰 F V ≫ Pi.π (fun τ : Fin 1 → 𝒰.I₀ => ...) σ = F.presheaf.map (homOfLE (stubInterLeV 𝒰 V σ)).op`, i.e. the σ-coordinate of ε_can is the plain presheaf restriction Γ(V,F) → Γ(∩_l(U_σl ∩ V), F); matches blueprint exactly.
- **Proof follows sketch**: yes — proof follows the blueprint route: unwinds `coreIso_objIso 0 ≫ Pi.π σ` through `pushPull_sigma_iso_π`, collapses the Čech augmentation through the terminal object (`cechAugmentation_pushPullMap`), uses `unit_pushPull_leg_sections`, and collapses parallel restriction chains.
- **notes**: `maxHeartbeats` and `synthInstance.maxHeartbeats` raised; inline comments explain instance-synthesis cost. AugSeam private helpers (`stubEqToHomRestr`, `rawPushPullMap_unit`, `cechNervePointIso_inv_eq_unit`, `cechAugmentation_pushPullMap`, `unit_pushPull_leg_sections`) are correctly `private` and serve this proof.

### `\lean{AlgebraicGeometry.cechSection_complex_iso, AlgebraicGeometry.sectionCechComplexV}` (chapter: `lem:cechSection_complex_iso`, line 9051)
- **Lean target exists**: yes (`cechSection_complex_iso`, line 123; `sectionCechComplexV` is in an upstream file, not this one — expected since the blueprint covers multiple files under one chapter)
- **Signature matches**: yes — returns `D ≅ (sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V) (sectionCechAugV_comp_d 𝒰 F V)` where D is the evaluated augmented Čech complex. Uses the CANONICAL `sectionCechAugV` (not a free `ε`), matching the blueprint's NOTE: "augmentation ε_can is the CANONICAL augmentation… NOT a free parameter."
- **Proof follows sketch**: yes — proof applies `mapHC_augment_iso` twice (for Ψ and GV), then `augmentCochainIso` with `coreIso`, `eY = Iso.refl _`, and `hcompat`. The blueprint's three steps (peel node via `mapHC_augment_iso`, assemble iso via `augmentCochainIso`, non-augmented core via `isoOfComponents`) are all present. The degree-0 compatibility `hcompat` is proved by `rw [happ, sectionCechAugV]; exact (Category.id_comp _).symm`, correctly reflecting the blueprint's "definitional" closure claim.
- **notes**: Body is a fully substantive proof. `coreIso` and `eY` are let-bindings (transparent), which is what makes `hcompat` close definitionally — consistent with the blueprint NOTE.

### `\lean{AlgebraicGeometry.cechSection_contractible, ...}` (chapter: `lem:cechSection_contractible`, line 9175)
- **Lean target exists**: yes (line 1109); all helper declarations listed in the `\lean{...}` block are present in the file.
- **Signature matches**: yes — `Homotopy (𝟙 ((sectionCechComplexV 𝒰 F V).augment (sectionCechAugV 𝒰 F V) (sectionCechAugV_comp_d 𝒰 F V))) 0` with hypothesis `V ≤ coverOpen 𝒰 i_fix`; matches blueprint's "contracting homotopy id_{D'_aug} ≃ 0" assuming V inside one cover member.
- **Proof follows sketch**: yes — proof uses `Homotopy.mkCoinductive` with three components: `cechSectionHomotopyZero` (π_{i_fix} at the augmentation node), `cechSectionHomotopyComp m` (prepend-i_fix in Čech degrees), and the coinductive step via `cechSection_succ_step`. The three correctness lemmas (I0)/(I1)/(In) (`cechSection_comm_zero`, `cechSection_comm_one`, `cechSection_comm_succ`) are all proved, and the engine instantiation (`depHomotopy_spec`) matches the blueprint's "positive Čech degrees via engine" + "augmentation node by hand" split.
- **notes**: `maxRecDepth 8000` and `maxHeartbeats 1600000` set; inline comments explain the coinductive assembly.

---

## Red flags

None found.

### Placeholder / suspect bodies
*None.* No `:= sorry` at any level. The `:= rfl` occurrences are `have`-step definitional equalities (lines 484, 527, 603, 615, 626, 631, 641) inside full proofs — all mathematically correct and intentional.

### Excuse-comments
*None.* Comments in the file are:
- Technical tuning notes (`-- raised: ...`) explaining heartbeat increases — legitimate.
- A `/-  Planner strategy: ... -/` block comment inside `cechSection_complex_iso` and `cechSection_contractible` — these are embedded planning notes, not excuses for incomplete or wrong code; both proofs are complete.
- Module-level docstring disclosing the `sorryAx` taint from upstream (`coreIso_comm_leg` in `CechSectionIdentificationLeg.lean`) — accurate and appropriate disclosure, not an excuse for this file.

### Axioms / Classical.choice on non-trivial claims
*None.* No `axiom` declarations. No `Classical.choice _` patterns.

---

## Unreferenced declarations (informational)

The AugSeam section private helpers are not listed in any `\lean{...}` block:
- `stubEqToHomRestr` (line 375)
- `rawPushPullMap_unit` (line 388)
- `cechNervePointIso_inv_eq_unit` (line 409)
- `cechAugmentation_pushPullMap` (line 441)
- `unit_pushPull_leg_sections` (line 460)

All five are `private` lemmas that exist solely to support the proof of `sectionCechAugV_π`. Their names do not suggest they should be promoted to the blueprint (they are technical sub-steps of a single proof). The blueprint's proof sketch for `lem:sectionCechAugV_π` implicitly covers their content ("factors through the terminal object… per-leg section identification reads as the plain restriction"). Minor informational note only.

---

## Blueprint adequacy for this file

- **Coverage**: 5/5 public declarations have a corresponding `\lean{...}` block. All private helpers of `cechSection_contractible` are comprehensively listed in `lem:cechSection_contractible`'s `\lean{...}` hint. The 5 AugSeam private helpers of `sectionCechAugV_π` are unlisted but appropriately so (private sub-steps of one proof).
- **Proof-sketch depth**: adequate. Each of the five blueprint blocks carries a proof sketch that matches the actual proof strategy:
  - `lem:sectionCechAugV_comp_d`: conjugation + functoriality argument → matches `rw/erw/Functor.map_comp/map_zero` chain.
  - `lem:sectionCechAugV_π`: terminal-object collapse + leg identification → matches `cechAugmentation_pushPullMap` + `unit_pushPull_leg_sections` route.
  - `lem:cechSection_complex_iso`: peel-node (mapHC_augment_iso × 2) + augmentCochainIso → matches exactly.
  - `lem:cechSection_contractible`: mkCoinductive + engine (depHomotopy_spec) + augmentation node by hand → matches I0/I1/In structure.
- **Hint precision**: precise. All `\lean{...}` fully-qualified names are correct and present in this file (or the appropriate upstream file for `sectionCechComplexV`). No ambiguous predicate names.
- **Generality**: matches need. Blueprint and Lean agree on the level of generality (arbitrary finite open cover, arbitrary quasi-coherent module, arbitrary open V).
- **Recommended chapter-side actions**: none. The blueprint is adequate for this file.

---

## Severity summary

No must-fix-this-iter, major, or minor findings.

**Note on `sorryAx` taint**: The module docstring correctly discloses that `cechSection_complex_iso` and `cechSection_contractible` are transitively `sorryAx`-tainted through `coreIso_comm_leg` in `CechSectionIdentificationLeg.lean`. This taint lives upstream; the file itself is sorry-free. The absence of `\leanok` markers on these blocks is therefore correct behavior (the `sync_leanok` phase would not add `\leanok` to tainted declarations). This is not a finding against this file.

**Overall verdict**: `CechSectionIdentification.lean` is clean — 5 declarations checked, 0 red flags. All signatures match their blueprint blocks, all proofs follow the prescribed routes, no sorry, no placeholders, no axioms. Blueprint coverage is complete and proof sketches are adequate.
