# Lean ↔ Blueprint Check Report

## Slug
ts214

## Iteration
214

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj}` (chapter: def:scheme_modules_tensorobj)
- **Lean target exists**: yes (line 640)
- **Signature matches**: yes — `(M N : X.Modules) : X.Modules` via sheafification of the presheaf tensor; matches blueprint def.
- **Proof follows sketch**: yes — body is a direct construction (not sorry); matches blueprint §1 description.
- **notes**: `\leanok` correctly placed.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality}` (chapter: lem:scheme_modules_tensorobj_functoriality)
- **Lean target exists**: yes (line 656)
- **Signature matches**: yes — `(f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N'` via `sheafification.map`.
- **Proof follows sketch**: yes
- **notes**: `\leanok` correctly placed.

### `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` (chapter: lem:restrictscalars_laxmonoidal)
- **Lean target exists**: yes (line 147)
- **Signature matches**: yes — `LaxMonoidal` instance for `restrictScalars α` where `α` is a morphism of presheaves of commutative rings. Helpers `restrictScalarsLaxε`, `restrictScalarsLaxμ` present.
- **Proof follows sketch**: yes — assembled sectionwise from `ModuleCat.restrictScalars` lax-monoidal data, matching the blueprint proof sketch.
- **notes**: `\leanok` correctly placed.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso}` (chapter: lem:tensorobj_restrict_iso)
- **Lean target exists**: yes (line 901)
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M N : X.Modules) : (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`.
- **Proof follows sketch**: partial — the three-step structure (restrictFunctorIsoPullback → sheafificationCompPullback → mapIso of presheaf comparison) matches the blueprint's Steps 1–3; the residual sorry at step 4 is the presheaf-level comparison (H1+H2), also identified as "off the critical path" in the blueprint. Consistent.
- **notes**: Body has `sorry` at step 4; `\leanok` correctly placed (statement exists with sorry body).

### `\lean{PresheafOfModules.W_whiskerLeft_of_flat, PresheafOfModules.W_whiskerRight_of_flat}` (chapter: lem:flat_whisker_localizer)
- **Lean target exists**: yes — `W_whiskerLeft_of_flat` at line 332, `W_whiskerRight_of_flat` at line 348.
- **Signature matches**: yes — both require `[∀ X, Module.Flat (R.obj X) (F.obj X)]`; match blueprint's "sectionwise flat" hypothesis.
- **Proof follows sketch**: yes — lTensor_exact kernel argument for injectivity, right-exactness for surjectivity, braiding conjugate for right-whisker. Matches blueprint proof.
- **notes**: Blueprint correctly notes these are superseded on the critical path by the `_of_W` variants. No `\leanok` on this lemma block in blueprint; blueprint is correct in leaving it without (the lemma has no `\leanok` marker).

### `\lean{PresheafOfModules.isIso_sheafification_map_of_W}` (chapter: lem:isiso_sheafification_map_of_W)
- **Lean target exists**: yes (line 488)
- **Signature matches**: yes — takes `hf : J.W ((toPresheaf R₀).map f)` and produces `IsIso ((sheafification α).map f)`. Matches blueprint.
- **Proof follows sketch**: yes — reads `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` at one morphism.
- **notes**: `\leanok` correctly placed.

### `\lean{PresheafOfModules.isLocallyInjective_whiskerLeft_of_W}` (chapter: lem:islocallyinjective_whisker_of_W)
- **Lean target exists**: yes (line 411)
- **Signature matches**: partial — **the Lean adds a typeclass hypothesis `[J.WEqualsLocallyBijective Ab.{u}]` that the blueprint statement does not mention.** The blueprint describes J.W as "the sheafification localizer (the locally bijective morphisms)" in the statement preamble but never names `WEqualsLocallyBijective` as a required typeclass. Every other hypothesis (F arbitrary, g : M ⟶ N, hg : J.W (...map g)) matches.
- **Proof follows sketch**: N/A — body is `sorry`; the sorry is authorized by the blueprint ("the sole remaining open obligation").
- **notes**: `\leanok` correctly placed (statement block has an authorized sorry). See Blueprint Adequacy section for the detailed gap in the proof sketch.

### `\lean{PresheafOfModules.W_whiskerLeft_of_W, PresheafOfModules.W_whiskerRight_of_W}` (chapter: lem:whisker_of_W)
- **Lean target exists**: yes — `W_whiskerLeft_of_W` at line 451, `W_whiskerRight_of_W` at line 464.
- **Signature matches**: yes — `[J.WEqualsLocallyBijective Ab.{u}]`, F arbitrary, hg : J.W, conclusion : J.W (toPresheaf.map (F ◁ g)).
- **Proof follows sketch**: yes — reduces to isLocallyInjective_whiskerLeft_of_W + isLocallySurjective_whiskerLeft + braiding conjugate.
- **notes**: No `\leanok` on `lem:whisker_of_W` in blueprint (correct: the injectivity half has sorry).

### `\lean{AlgebraicGeometry.Scheme.Modules.IsInvertible}` (chapter: def:scheme_modules_isinvertible)
- **Lean target exists**: yes (line 669)
- **Signature matches**: yes — `∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)`. Matches blueprint definition exactly.
- **notes**: `\leanok` correctly placed.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor, AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor}` (chapter: lem:tensorobj_unit_iso)
- **Lean target exists**: yes — `tensorObj_left_unitor` at line 730, `tensorObj_right_unitor` at line 740.
- **Signature matches**: yes — both produce `≅ M` for the appropriate unitor. Matches blueprint.
- **notes**: Blueprint `lem:tensorobj_unit_iso` lacks `\leanok` even though both declarations exist as full constructions (not sorry). The `sync_leanok` phase should add `\leanok` here. Minor.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_braiding}` (chapter: lem:tensorobj_comm_iso)
- **Lean target exists**: yes (line 750)
- **Signature matches**: yes — `tensorObj M N ≅ tensorObj N M` via mapIso of braiding.
- **notes**: `\leanok` correctly placed.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso}` (chapter: lem:tensorobj_assoc_iso)
- **Lean target exists**: yes (line 800)
- **Signature matches**: partial — the Lean pin scopes to `(hM : LineBundle.IsLocallyTrivial M) (hN : ...) (hP : ...)`, i.e. carries locally-trivial hypotheses. The blueprint correctly documents these as **vestigial** ("not ingredients of the API-derived associator and may be dropped once lem:jw_ismonoidal lands"). The conceptual signature (an iso (M ⊗ N) ⊗ P ≅ M ⊗ (N ⊗ P)) matches; the vestigial hypotheses are a Lean engineering artefact, not a semantic mismatch.
- **Proof follows sketch**: yes — the three-step composite using `W_whiskerRight_of_W`/`W_whiskerLeft_of_W` + `isIso_sheafification_map_of_W` + `mapIso` of associator is faithfully realized (and is now axiom-clean). `\leanok` correctly placed.
- **notes**: The associator is now a full non-sorry proof (closed iter-212 or earlier). The blueprint correctly notes the locally-trivial hypotheses are vestigial.

### `\lean{AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse}` (chapter: lem:tensorobj_inverse_invertible)
- **Lean target exists**: yes (line 1009)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : ∃ Linv, IsLocallyTrivial Linv ∧ Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf)`. Authorized sorry.
- **notes**: `\leanok` correctly placed.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjOnProduct}` (chapter: lem:tensorobj_lift_onproduct)
- **Lean target exists**: yes (line 1021)
- **Signature matches**: yes — packages `tensorObj_isLocallyTrivial` into the `LineBundle.OnProduct` subtype. Matches blueprint.
- **notes**: `\leanok` correctly placed.

### `\lean{AlgebraicGeometry.Scheme.Modules.tensorObjIsoclassCommMonoid}` (chapter: lem:tensorobj_isoclass_commgroup)
- **Lean target exists**: **no** — this declaration does not appear in the Lean file. The namespace `AlgebraicGeometry.Scheme.Modules` closes at line 1026; no `tensorObjIsoclassCommMonoid` is defined anywhere.
- **Signature matches**: N/A — declaration absent.
- **notes**: The lemma block (`lem:tensorobj_isoclass_commgroup`) does NOT carry `\leanok`, so this is a prospective `\lean{...}` pin for an unformalized block — an intended target name, not a claimed formalization. This is consistent with the block's stated-but-unformalized status ("pending the sole sorry"). **Not a critical gap** under the checker's rules (no `\leanok` on the block), but the prospective name should be treated as the intended Lean identifier once `lem:jw_ismonoidal` lands.

### `\lean{AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj}` (chapter: thm:rel_pic_addcommgroup_via_tensorobj)
- **Lean target exists**: yes (line 1049)
- **Signature matches**: yes — `AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT))`. Authorized sorry.
- **notes**: `\leanok` correctly placed. `@[implicit_reducible]` attribute present — no blueprint comment on this; minor.

---

## Red flags

### Placeholder / suspect bodies (authorized sorries)

The following carry `:= sorry` bodies that are **explicitly authorized** by the blueprint (not red flags; listed for completeness):
- `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (line 443): authorized open obligation (lem:islocallyinjective_whisker_of_W sole sorry).
- `AlgebraicGeometry.Scheme.Modules.tensorObj_restrict_iso` (line 970): step 4 residual, off critical path.
- `AlgebraicGeometry.Scheme.Modules.exists_tensorObj_inverse` (line 1013): off critical path.
- `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (line 1052): consumer closure target.

No unauthorized sorries found.

### Excuse-comments

No "TODO: replace with real def" or "placeholder" comments found. Comments in the file accurately describe the state of the work.

### Axioms / Classical.choice on non-trivial claims

None found.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have **no** `\lean{...}` blueprint pin:

**`PresheafOfModules` namespace — helper declarations (acceptable as scaffolding):**
- `restrictScalarsLaxε` (line 114) — helper for `restrictScalarsLaxMonoidal`
- `restrictScalarsLaxμ` (line 130) — helper for `restrictScalarsLaxMonoidal`
- `toPresheaf_whiskerLeft_app_tmul` (line 201) — helper lemma
- `toPresheaf_whiskerLeft_app_apply` (line 210) — helper lemma
- `isLocallySurjective_whiskerLeft` (line 222) — helper (surjectivity half, consumed by `W_whiskerLeft_of_flat` and `W_whiskerLeft_of_W`)

**`PresheafOfModules.StalkLinearMap` section — iter-214 new declarations (substantive, see detailed analysis below):**
- `PresheafOfModules.stalkLinearMap` (line 535)
- `PresheafOfModules.stalkLinearMap_germ` (line 576)
- `PresheafOfModules.stalkLinearMap_bijective_of_isIso` (line 597)
- `PresheafOfModules.stalkLinearEquivOfIsIso` (line 610)

**`AlgebraicGeometry.Scheme.Modules` namespace:**
- `tensorObjIsoOfIso` (line 701) — helper for `tensorObj_isLocallyTrivial`
- `tensorObj_unit_iso` (line 717) — structural unit; feeds `tensorObj_isLocallyTrivial`
- `restrictIsoUnitOfLE` (line 855) — helper for `tensorObj_isLocallyTrivial`

---

## Directive-specific findings

### Finding 1: Lean → Blueprint — the four `stalkLinearMap*` declarations

**Are they represented in the chapter?** No. None of the four iter-214 declarations (`stalkLinearMap`, `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`, `stalkLinearEquivOfIsIso`) appears under any `\lean{...}` pin in the chapter.

**Are they acceptable as below-blueprint-altitude scaffolding, or should the chapter mention them?**

They are **substantive project-side infrastructure, not mere helpers**, and the chapter should add blueprint coverage of them. Specifically:

- The chapter's proof sketch for `lem:islocallyinjective_whisker_of_W` (lines 796–808) itemizes d.1 as "the stalkwise characterisation of the module-level J.W on Opens X." The four declarations ARE the concrete Lean realization of d.1-partial (the linearity packaging half of ingredient d.1).
- The chapter's internal-consistency section (the long itemize at the end) mentions the residual ingredients d.1/d.2 abstractly, but does not name the project-side declarations that implement the d.1 partial build.
- Without `\lean{...}` pins on these declarations, the next prover who reads the chapter to continue the d.1 work cannot identify what is already built vs. what remains.

The `StalkLinearMap` section is labeled "Project-local Mathlib supplement — the R.stalk x-linear stalk map (ROUTE (e), ingredient d.1)" in the Lean file (lines 502–519), and all four declarations have detailed docstrings explaining their role. This is blueprint-level significance.

**Severity: major** — the chapter should add a brief subsection (or at least a `\lean{...}`-pinned lemma block) for these four declarations, marking them as the d.1 partial implementation.

### Finding 2: Blueprint → Lean — `lem:islocallyinjective_whisker_of_W` proof sketch is outdated

**Does the blueprint's statement match the Lean signature?** Nearly. One discrepancy: the Lean carries the typeclass assumption `[J.WEqualsLocallyBijective Ab.{u}]` that the blueprint statement does not name. This is minor — the typeclass is implicit in the blueprint's "J.W = locally bijective morphisms" language, but its explicit Lean name is absent.

**Is the proof sketch detailed enough to guide the next prover?**

**No.** Two specific gaps:

**(a) The claim "no PresheafOfModules stalk/fiber/point infrastructure" (chapter section 2, lines 248–251) is factually wrong post-iter-214.**

The blueprint currently reads:
> "there is no monoidal SheafOfModules, and no PresheafOfModules stalk/fiber/point infrastructure (only Presheaf/ColimitFunctor)"

This was accurate at iter-202 but is wrong now. Mathlib's `Mathlib.Algebra.Category.ModuleCat.Stalk` supplies the stalk module structure (`Module (R.stalk x) ↑(stalk M.presheaf x)` and `germ_smul`) for `X : TopCat, R : X.Presheaf CommRingCat`. The Lean file's own comment (lines 421–424) explicitly corrects this: "the module-level stalk is NOT Mathlib-absent." The chapter needs to update this paragraph.

**(b) The proof sketch for `lem:islocallyinjective_whisker_of_W` (lines 796–808) does not decompose d.1 into "done" and "remaining" sub-parts.**

The current sketch says (paraphrasing):
> - (d.1) stalkwise characterisation of J.W on Opens X: absent from Mathlib
> - (d.2) stalk ⊗ commutation (A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x: absent from Mathlib

But the true picture after iter-214 is:
- **d.1-done**: `stalkLinearMap*` packaging (the linearity of the induced stalk map) — NOW BUILT project-side, axiom-clean.
- **d.1-bridge (remaining)**: `(Opens.grothendieckTopology X).W g ↔ ∀ x, IsIso (stalkFunctor Ab x map)` — still needed; assembles from `HasEnoughPoints`, `W_iff`, or `WEqualsLocallyBijective` + `app_injective_iff_stalkFunctor_map_injective`.
- **d.2 (remaining)**: stalk ⊗ commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` identifying `(F ◁ g)_x` with `LinearMap.lTensor F_x (stalkLinearMap g x)` — genuinely Mathlib-absent, largest piece.

A prover reading the current blueprint sketch would not know that `stalkLinearMap*` is already built (no re-implementation needed), that the d.1 residual is specifically the site-W↔stalkwise-iso bridge (not the full stalkwise infrastructure), or that the concrete closure route is `stalkLinearMap_bijective_of_isIso` + `LinearEquiv.lTensor` once d.1-bridge and d.2 land.

**Severity: major** — the proof sketch is stale/incomplete; the next prover will waste effort if they read only the blueprint.

### Finding 3: `\lean{...}` pin correctness check

All `\lean{...}` pins on `\leanok`-marked blocks resolve to existing Lean declarations. The one pin pointing at a non-existent declaration (`tensorObjIsoclassCommMonoid` for `lem:tensorobj_isoclass_commgroup`) is on a block without `\leanok`, so it is a legitimate prospective target name — not a claim of existing formalization. No fake or placeholder `\lean{...}` pins.

---

## Blueprint adequacy for this file

- **Coverage**: 15 of the ~20 substantive Lean declarations have a corresponding `\lean{...}` block in the chapter. The four `stalkLinearMap*` declarations are unreferenced (significant gap; flagged above). Several helpers (`tensorObjIsoOfIso`, `tensorObj_unit_iso` used as a structural intermediate, `restrictIsoUnitOfLE`) are acceptably below blueprint altitude.
- **Proof-sketch depth**: **under-specified** for `lem:islocallyinjective_whisker_of_W`. The sketch is stale (states all of d.1 as Mathlib-absent when d.1-partial is now built), and does not give the next prover enough context to write the remaining d.1-bridge and d.2 without re-reading the Lean file's comments.
- **Hint precision**: **loose** in one place: `[J.WEqualsLocallyBijective Ab.{u}]` is an explicit Lean typeclass hypothesis for `isLocallyInjective_whiskerLeft_of_W` that the chapter doesn't name in the statement prose.
- **Generality**: matches need — declarations are at the right level of generality.
- **Recommended chapter-side actions**:
  1. Add a short named block (or at minimum `\lean{...}`-pinned remark) for the `StalkLinearMap` section covering all four declarations, describing them as the d.1 partial implementation.
  2. Update the API survey (section 2, `\paragraph{The gap and route (e)}`, line 248–251) to correct the claim that there is "no PresheafOfModules stalk/fiber/point infrastructure": Mathlib has `ModuleCat/Stalk.lean` (stalk module structure for `X : TopCat`, `R : X.Presheaf CommRingCat`); what Mathlib lacks is only the *linearity packaging* of the induced stalk map, and project-side `stalkLinearMap*` now fills that.
  3. Update the proof sketch of `lem:islocallyinjective_whisker_of_W` to separate d.1 into done (`stalkLinearMap*`) and remaining (d.1-bridge: J.W ↔ stalkwise iso; d.2: stalk ⊗ commutation), citing the specific Lean declarations now in place.
  4. Add `[J.WEqualsLocallyBijective Ab.{u}]` to the statement block of `lem:islocallyinjective_whisker_of_W`.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| Four `stalkLinearMap*` declarations unreferenced by any `\lean{...}` pin | **major** |
| Blueprint API survey claims "no stalk infrastructure" — factually wrong post-iter-214 | **major** |
| Proof sketch of `lem:islocallyinjective_whisker_of_W` stale/incomplete (d.1 split) | **major** |
| `[J.WEqualsLocallyBijective Ab.{u}]` missing from blueprint statement | **minor** |
| `lem:tensorobj_unit_iso` (both unitors) missing `\leanok` (sync_leanok should fix) | **minor** |

**Overall verdict**: All pinned declarations exist with correct signatures and authorized sorry-bodies; no fake/placeholder or rogue-axiom issues. The single `sorry`-bearing obligation (`isLocallyInjective_whiskerLeft_of_W`) is correctly authorized. The two **major** blueprint adequacy findings — unreferenced `stalkLinearMap*` declarations and a stale proof sketch — prevent the blueprint from serving as an accurate guide for the next prover working on the d.1 residual; a blueprint-writing pass is needed before the next d.1/d.2 prover iteration.

Total: 17 blueprint-pinned declaration blocks checked (15 with `\lean{...}` pins on `\leanok` blocks, 2 prospective pins on unformalized blocks); 2 major blueprint gaps; 0 Lean-side must-fix findings.
