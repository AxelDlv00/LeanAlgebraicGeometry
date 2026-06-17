# Lean ↔ Blueprint Check Report

## Slug
ts227

## Iteration
227

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (2149 lines)
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (2897 lines)

---

## Per-declaration (iter-227 new decls)

### `restrictScalarsRingIsoDualEquiv` (Lean L306)

- **Lean target exists**: yes — `noncomputable def restrictScalarsRingIsoDualEquiv` at L306
- **Blueprint `\lean{...}` pin**: **MISSING** — no `\lean{restrictScalarsRingIsoDualEquiv}` appears anywhere in the blueprint
- **Signature check**: The Lean docstring describes it as "the ModuleCat-level H2′ ingredient of the C-bridge `(dual M).restrict f ≅ dual (M.restrict f)` along an open immersion `f`." It provides an `R`-linear equivalence `(M →ₗ[S] S) ≃ₗ[R] (M →ₗ[R] R)` given a ring iso `e : R ≃+* S`. This is the dual analogue of `restrictScalarsRingIsoTensorEquiv` (blueprint `lem:restrictscalars_ringiso_tensorequiv`). The blueprint has no corresponding block for the dual form.
- **Proof follows sketch**: N/A — no blueprint sketch exists for this declaration.
- **Axiom-clean**: yes — full proof body, no `sorry`.
- **Notes**: The `sec:tensorobj_dual_infra` section covers the presheaf dual and internal hom but has no block for the H2′ ring-iso dual equivalence. The closest analog is `lem:restrictscalars_ringiso_tensorequiv` (for tensor) in `sec:tensorobj_substrate`. A companion lemma block for the dual form should be added to `sec:tensorobj_dual_infra` with `\lean{restrictScalarsRingIsoDualEquiv}`.

---

### `AlgebraicGeometry.Scheme.Modules.homMk` (Lean L2034)

- **Lean target exists**: yes — `noncomputable def homMk` at L2034
- **Blueprint `\lean{...}` pin**: **MISSING** — no `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` appears in the blueprint. The blueprint's proof of `lem:sheafofmodules_hom_of_local_compat` (L2847) mentions `PresheafOfModules.homMk` *in prose* as an implementation tool, but the thin project-side wrapper `Scheme.Modules.homMk` is not pinned.
- **Signature check**: The Lean signature wraps `PresheafOfModules.homMk` at the `Scheme.Modules` level. Given `g : M.val.presheaf ⟶ N.val.presheaf` and a sectionwise `𝒪_X`-linearity proof `hg`, it returns `M ⟶ N` in `X.Modules`. This is the "A-bridge step (ii): promote to `𝒪_X`-linear" half needed by `homOfLocalCompat`.
- **Proof follows sketch**: N/A — no dedicated blueprint block. The blueprint mentions it only as an implementation detail.
- **Axiom-clean**: yes — body is `⟨PresheafOfModules.homMk … g hg⟩`, no `sorry`.
- **Notes**: This declaration is a substantive project-side helper (not just a one-liner alias — it packages the linearity hypothesis). It should have a dedicated `\lean{...}` pin, either as a standalone helper block near `lem:sheafofmodules_hom_of_local_compat` or as part of a combined "building-block" lemma covering both this and `toPresheaf_map_homMk`.

---

### `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (Lean L2042)

- **Lean target exists**: yes — `@[simp] lemma toPresheaf_map_homMk` at L2042
- **Blueprint `\lean{...}` pin**: **MISSING**
- **Signature check**: States that `(Scheme.Modules.toPresheaf X).map (homMk g hg) = g` (`rfl`). Correct companion simp lemma for `homMk`.
- **Axiom-clean**: yes — body is `rfl`.
- **Notes**: Acceptable as an unreferenced helper. No dedicated blueprint block needed, but it should appear alongside a `homMk` block if one is added.

---

### `AlgebraicGeometry.Scheme.Modules.homOfLocalCompat` (blueprint L2814, `lem:sheafofmodules_hom_of_local_compat`)

- **Lean target exists**: **NO** — this declaration does not appear in `TensorObjSubstrate.lean`. It is referenced in Lean comments at L2031 and L2068 as a future target ("the A-bridge `homOfLocalCompat`"), but is not defined. The directive confirms it "did NOT land."
- **Blueprint pin**: `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` at blueprint L2814. The block does NOT carry `\leanok`, so the non-existence in Lean is correctly reflected. This is an **authorized forward pin**, not an error introduced by iter-227.
- **Signature matches**: N/A — declaration absent.
- **Proof follows sketch**: N/A — declaration absent.
- **Notes**: Pre-existing forward pin. See Blueprint Adequacy section for the sketch depth assessment.

---

## Red Flags

### Placeholder / suspect bodies

The following unrelated declarations carry authorized `sorry` bodies, already documented in prior iterations and consistent with the blueprint state (no `\leanok` on their proof blocks):

- `isLocallyInjective_whiskerLeft_of_W` (L659): `:= sorry`. Blueprint `lem:islocallyinjective_whisker_of_W` has `\leanok` on the *statement* (correctly, since the declaration exists with a sorry) but no `\leanok` on the proof block. The sorry is documented as the route-(e) fallback residual. **Not a must-fix.**
- `exists_tensorObj_inverse` (L2074): `:= sorry`. Blueprint `lem:tensorobj_inverse_invertible` has `\leanok` on the statement. The sorry is documented and authorized; two remaining bridges (`dual_isLocallyTrivial`, `homOfLocalCompat`) are needed before it closes. **Not a must-fix.**
- `addCommGroup_via_tensorObj` (L2139): `:= sorry`. Blueprint `thm:rel_pic_addcommgroup_via_tensorobj` has `\leanok` on the statement. Documented as the consumer that closes once `exists_tensorObj_inverse` lands. **Not a must-fix.**

### Excuse-comments

None on the three new declarations. The new declarations (`restrictScalarsRingIsoDualEquiv`, `homMk`, `toPresheaf_map_homMk`) all carry accurate mathematical docstrings and no excuse-comments.

### Axioms / Classical.choice on non-trivial claims

None introduced in iter-227 for the three new declarations.

---

## Unreferenced declarations (informational)

Declarations in the Lean file with no corresponding `\lean{...}` blueprint pin:

**Substantive (flag):**
- `restrictScalarsRingIsoDualEquiv` (L306) — H2′ C-bridge ingredient; should have a blueprint block in `sec:tensorobj_dual_infra`. See above.
- `AlgebraicGeometry.Scheme.Modules.homMk` (L2034) — A-bridge step (ii); should have a blueprint block near `lem:sheafofmodules_hom_of_local_compat`. See above.

**Helper (acceptable, low priority):**
- `restrictScalarsRingIsoTensorEquiv_apply_tmul` (L206): `@[simp]` companion to `restrictScalarsRingIsoTensorEquiv`. Acceptable as unreferenced helper.
- `restrictScalars_isIso_μ` (L228), `restrictScalars_isIso_ε` (L246), `restrictScalars_isIso_ε_of_bijective` (L283): These are grouped under `lem:restrictscalars_ringiso_strongmonoidal` in the blueprint's `\lean{...}` multi-name list. They ARE referenced.
- `toPresheaf_whiskerLeft_app_tmul` (L449), `toPresheaf_whiskerLeft_app_apply` (L459): helpers under `lem:flat_whisker_localizer`; acceptable as unreferenced helpers.
- `stalkLinearMap` (L783), `stalkLinearMap_germ` (L824), `stalkLinearMap_bijective_of_isIso` (L845), `stalkLinearEquivOfIsIso` (L858): `lem:stalk_linear_map` (blueprint L1078) describes these but carries no `\lean{...}` pin (it's in the superseded route section). Gap is pre-existing and acceptable for superseded code.
- `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (L2042): `@[simp]` companion, acceptable.
- `InternalHom.termRingMap_terminal` (L1378): helper for `internalHomEval`; acceptable as unreferenced.
- `InternalHom.evalLin`, `evalLin_add`, `evalLin_smul` (L1414–L1435): helpers for `internalHomEvalApp`; acceptable.
- `InternalHom.internalHomEvalApp_tmul` (L1478): `@[simp]` companion; acceptable.

---

## Blueprint adequacy for this file

### Coverage
24 `\lean{...}` pins in the chapter. Of these:
- 22 point to declarations that exist in the Lean file (confirmed or consistent with prior-iter verification).
- 2 are authorized forward pins pointing to not-yet-formalized declarations:
  - `homOfLocalCompat` (L2814) — primary target of iter-227+, no `\leanok`.
  - `dual_isLocallyTrivial` (L2736) — C-bridge target, no `\leanok`.

3 iter-227 declarations lack any `\lean{...}` pin: `restrictScalarsRingIsoDualEquiv` (substantive), `homMk` (substantive), `toPresheaf_map_homMk` (helper).

**Coverage score: 22/25 substantive declarations are pinned (missing 2 substantive + 1 minor).**

### Proof-sketch depth for `homOfLocalCompat`
**Under-specified.** The blueprint's proof sketch for `lem:sheafofmodules_hom_of_local_compat` (L2823–2854) correctly identifies the two-step structure:
1. Glue the underlying ab-sheaf morphism via `Presheaf.IsSheaf.hom` / `sheafHomSectionsEquiv`.
2. Promote to `𝒪_X`-linear via `PresheafOfModules.homMk`.

However:
- The sketch names `sheafHomSectionsEquiv` but the actual Lean path is likely through `existsUnique_gluing` on the `TopCat.Sheaf` / `presheafHom` sheaf of hom groups. These are distinct API routes and the sketch does not resolve which Mathlib API to call.
- The `localSection` naturality issue (flagged in the project's memory: "`localSection` naturality is the risk") is not mentioned in the blueprint at all.
- The implementation is estimated at ~120–190 LOC by the prover (memory: "blocker is build SIZE not d.2. Plan's 30-60 LOC est unrealistic"). The blueprint's prose (~30 lines) does not foreshadow this complexity.
- The "separated presheaf" argument for linearity promotion (step ii) is stated informally without naming the exact Lean separatedness API (`IsSheaf.isSeparated` or similar).

**Recommendation:** The blueprint should expand the proof sketch to:
1. Name the specific Lean API path for step (i): whether `existsUnique_gluing`, `sheafHomSectionsEquiv`, or `CategoryTheory.Presheaf.IsSheaf.hom` (with a note on which is available at the pinned Mathlib commit and what type the "compatible family" has in Lean).
2. Identify the `localSection` naturality obligation and whether it is discharged by the Mathlib sheaf API or needs a manual proof.
3. Estimate the proof size (~120–190 LOC) and identify the dominant subgoals.

### Hint precision
**Loose for `homOfLocalCompat`**, **precise for established declarations.** The existing 22 pins are precisely stated. The forward pin `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` names the right target, and the statement in the blueprint is a faithful formalization target. The imprecision is in the proof route.

### Generality
**Matches need** for all existing declarations. The blueprint correctly avoids over-generalizing or under-specifying the formalized declarations.

### Recommended chapter-side actions for a blueprint-writing subagent
1. **Add `lem:restrictscalars_ringiso_dualequiv`** in `sec:tensorobj_dual_infra` — a new lemma block for `restrictScalarsRingIsoDualEquiv`, mirroring `lem:restrictscalars_ringiso_tensorequiv` for the dual case. Include `\lean{restrictScalarsRingIsoDualEquiv}` pin and a proof sketch (the docstring in the Lean file suffices as source material).
2. **Add a helper block for `Scheme.Modules.homMk`** near `lem:sheafofmodules_hom_of_local_compat` — a brief `\lean{AlgebraicGeometry.Scheme.Modules.homMk}` pin with one-line description as "A-bridge step (ii): the scheme-level thin wrapper packaging `PresheafOfModules.homMk` with a sectionwise-linearity hypothesis."
3. **Expand the proof sketch** of `lem:sheafofmodules_hom_of_local_compat` to name the specific Lean API path (`existsUnique_gluing` vs `sheafHomSectionsEquiv`), flag the `localSection` naturality obligation, and revise the size estimate.

---

## Severity summary

- **must-fix-this-iter**: None. The three new declarations are axiom-clean, their signatures are mathematically correct, and they contain no placeholders or excuse-comments. The forward pin `homOfLocalCompat` is pre-authorized (no `\leanok` on its block).

- **major**:
  1. `restrictScalarsRingIsoDualEquiv` (L306) has no `\lean{...}` blueprint pin. As the H2′ C-bridge ingredient in `sec:tensorobj_dual_infra`, it should have a dedicated block. A blueprint-writing subagent should add one.
  2. `AlgebraicGeometry.Scheme.Modules.homMk` (L2034) has no `\lean{...}` blueprint pin. As the project-side A-bridge helper consumed by `homOfLocalCompat`, it needs a pin.
  3. Blueprint proof sketch for `lem:sheafofmodules_hom_of_local_compat` is under-specified relative to the ~120–190 LOC Lean implementation: the Lean API path (particularly `existsUnique_gluing` vs `sheafHomSectionsEquiv`) and the `localSection` naturality risk are not addressed. This will likely cost the prover significant iteration.

- **minor**:
  - `AlgebraicGeometry.Scheme.Modules.toPresheaf_map_homMk` (L2042) has no blueprint pin (acceptable for a `@[simp]` companion, but should be co-located with a future `homMk` block).

**Overall verdict:** The three iter-227 declarations are axiom-clean with correct signatures; no must-fix issues on the Lean side, but two of the three lack blueprint `\lean{...}` pins (major), and the blueprint proof sketch for the primary target `homOfLocalCompat` is under-specified for the ~120–190 LOC Lean implementation it requires.
