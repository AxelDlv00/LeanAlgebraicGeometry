# Lean ↔ Blueprint Check Report

## Slug
di253

## Iteration
253

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
  (relevant labels: `lem:sheafofmodules_hom_of_local_compat`, `lem:dual_restrict_iso`,
  `lem:scheme_modules_hom_local_section`, `lem:dual_isLocallyTrivial`, `lem:dual_unit_iso`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`)
- **Lean target exists**: yes (line 230)
- **Signature matches**: yes — `{X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) : (dual M).restrict f ≅ dual (M.restrict f)` matches the blueprint statement exactly.
- **Proof follows sketch**: partial — Steps 1–3 (reduce `restrict` to `pullback` via `restrictFunctorIsoPullback`, move pullback inside sheafification via `sheafificationCompPullback`, strip outer sheafification via `sheafification.mapIso`) are closed axiom-clean. The H1 (`pushforwardPushforwardAdj` + `leftAdjointUniq`) route is assembled. Step 4 is `sorry` (line 256).
- **Notes**: The Step 4 sorry is the "genuine new build" (`(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`) described by the blueprint's Leg (A)/(B) analysis. The blueprint's proof sketch is detailed and correct at this resolution; the sorry represents an open mathematical build, not a mismatch. 1 sorry total.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`)
- **Lean target exists**: yes (line 274)
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf` matches the blueprint's `dual 𝒪_Y ≅ 𝒪_Y`.
- **Proof follows sketch**: yes — the Lean implements exactly "sheafify the presheaf-level evaluation-at-1 iso, then apply the sheafification counit": `sheafification.mapIso presheafDualUnitIso ≪≫ (asIso counit).app unit`. `presheafDualUnitIso` wraps `dualUnitIsoGen`, which builds the evaluation-at-1 equivalence sectionwise. Blueprint says "No left unitor is needed" — Lean agrees (no λ_ used).
- **Notes**: axiom-clean.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`)
- **Lean target exists**: yes (line 332)
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : LineBundle.IsLocallyTrivial (dual L)` matches.
- **Proof follows sketch**: yes — three-step chain `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` exactly mirrors the blueprint's Steps 1–3.
- **Notes**: 0 direct sorries; transitively inherits Step 4 sorry from `dual_restrict_iso`. The chain assembly matches the blueprint faithfully.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`)
- **Lean target exists**: yes (line 355)
- **Signature matches**: yes — constructs a section of `(presheafHom M.val.presheaf N.val.presheaf).obj (op (U i))` from `f i`, with components `M.map (eqToHom ..) ≫ (f i).val.app .. ≫ N.map (eqToHom ..)`. Matches blueprint description.
- **Proof follows sketch**: yes — naturality via `hML`/`hNR` (eqToHom reassociation) plus `erw [reassoc_of% hm]` + `Subsingleton.elim` for the thin-poset squares (as `hsubM`/`hsubN`). The blueprint says "coherence is automatic on the thin poset by `Subsingleton.elim`" — Lean does exactly this.
- **Notes**: axiom-clean. No blueprint proof block (the blueprint statement gives enough description; see Blueprint Adequacy below).

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`)
- **Lean target exists**: yes (line 500)
- **Signature matches**: **partial — critical mismatch on `hf`**. See Red Flags below.
- **Proof follows sketch**: partial — sub-step (b) (topSectionToHom glue) is closed and matches the blueprint; sub-steps (a) and (c) are `sorry`. The (a) sorry has a documented fundamental blocker (the HEq-unconsumable form of `hf`); the (c) sorry is transitively gated on (a). 2 sorries total.
- **Notes**: See detailed analysis in Red Flags §1 and Blueprint Adequacy.

---

## Red Flags

### Placeholder / suspect bodies

**`homOfLocalCompat` — `hcompat` proof, line 565**: `:= sorry` on the `IsCompatible` condition.
This is not a trivial placeholder but a documented open mathematical problem — the HEq form of `hf` is unconsumable (see §1 below). This is a substantive open sorry on a claim the blueprint describes as derivable.

**`homOfLocalCompat` — linearity proof, line 581**: `:= sorry` on the `𝒪_X`-linearity of the glued morphism.
Transitively gated on the (a) sorry above (the glued section `(hglue hcompat).choose` doesn't exist until `hcompat` is proved). The linearity argument itself is mathematically independent and the blueprint's description is adequate for it; the sorry is contingent on (a), not on a linearity-specific obstacle.

**`dual_restrict_iso` — Step 4, line 256**: `:= sorry` on the presheaf residual
`(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`.
This is the "genuine new build" described by the blueprint's Legs (A)/(B). The sorry is an open mathematical task, not a placeholder body — the blueprint's sketch is detailed enough to guide it.

---

### Excuse-comments

None. The sorry comments in `homOfLocalCompat` are accurate blocker documentation (not excuses for wrong code); the `dual_restrict_iso` Step 4 comment is a legitimate open-build note.

---

### Critical: `hf` signature mismatch — `homOfLocalCompat` lines 500–508

This is the central must-fix finding of this report.

**What the Lean has:**
```lean
hf : ∀ i j,
    HEq ((Scheme.Modules.pullback
            (Scheme.Hom.resLE (𝟙 X) (U i) (U i ⊓ U j) inf_le_left)).map (f i))
        ((Scheme.Modules.pullback
            (Scheme.Hom.resLE (𝟙 X) (U j) (U i ⊓ U j) inf_le_right)).map (f j))
```

**The problem:** `Scheme.Modules.pullback` applied to `resLE ...` produces objects (source/target of `gi`, `gj`) that are *only isomorphic*, not propositionally equal. Specifically:
- `(pullback (resLE ...)).obj (M.restrict (U i).ι)` and `(pullback (resLE ...)).obj (M.restrict (U j).ι)` both equal `M.restrict (U i ⊓ U j).ι` *up to the nontrivial iso* `restrictFunctorIsoPullback`, which is not `rfl`.
- `gi` and `gj` are images of functors out of *different* source categories (`(U i).Modules` vs `(U j).Modules`).
- Every standard `HEq`-elimination (`eq_of_heq`, `HEq.elim`, `conj_eqToHom_iff_heq`, `subst`) requires the source/target objects to be propositionally equal as Lean terms — which fails here.
- Scratch-verified in an isolated `import Mathlib` environment (iter-253 comment): `rfl`, `exact?`, `congr 1` all fail on the object equality.
- Conclusion: `hf` *cannot be consumed* as stated. It is likely unsatisfiable by any caller, because no caller can produce an `HEq` between morphisms whose source types are only isomorphic.

**Internal inconsistency in the Lean file itself (major):**
The *docstring* of `homOfLocalCompat` (lines 432–449) says:
> "which are propositionally equal (both equal `M.restrict (U i ⊓ U j).ι` via `restrictFunctorComp`+`restrictFunctorCongr`) but not definitionally equal. The prover should establish `HEq` by first proving the types equal via `congr`+`restrictFunctorComp`, then `heq_of_eq`."

But the *proof body comment* (lines 547–564) says:
> "are NOT propositionally equal — only isomorphic (each is a *sheafification* of a pullback presheaf; `restrictFunctorIsoPullback` is a nontrivial iso)"

These are contradictory. The docstring describes an earlier design intent (using `restrictFunctor`, where `restrictFunctorComp` might give propositional equality); the proof body comment reflects what the actual signature (`Scheme.Modules.pullback`) implies. The proof body analysis is almost certainly correct: `Scheme.Modules.pullback` is implemented via sheafification of a pullback presheaf, making `restrictFunctorIsoPullback` genuinely nontrivial (not `rfl`), so the types are only isomorphic.

**What `hf` should look like:** Either
- **(a) Sectionwise form**: `∀ i j V (hVi : V ≤ U i) (hVj : V ≤ U j), (f i).val.app (op ((U i).ι ⁻¹ᵁ V)) = (f j).val.app (op ((U j).ι ⁻¹ᵁ V))` (in the common Ab hom-type `M.val.obj (op V) ⟶ N.val.obj (op V)`), OR
- **(b) `restrictFunctor` form** (if `restrictFunctorComp` actually gives propositional equality): `HEq ((restrictFunctor (resLE i)).map (f i)) ((restrictFunctor (resLE j)).map (f j))` — but only if propositional equality of source/target can be proved, which must be verified by the mathematician.

The Lean comment flags this as requiring mathematician intervention because `hf` is in the PROTECTED signature. (Note: `homOfLocalCompat` was not found in `archon-protected.yaml`, but the Lean comment at line 562 says "RECOMMENDATION (needs the mathematician — `hf` is in the PROTECTED signature)"; this may be guarded by convention rather than the YAML file.)

---

## Unreferenced declarations (informational)

| Declaration | File location | Notes |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | L63 | Helper for `dualUnitIsoGen`; clearly a sub-piece |
| `PresheafOfModules.dualUnitIsoGen` | L105 | Helper for `presheafDualUnitIso`; feeds the scheme-level `dual_unit_iso` |
| `Scheme.Modules.presheafDualUnitIso` | L263 | Local bridge between `dualUnitIsoGen` and `dual_unit_iso` |
| `Scheme.Modules.topSectionToHom` | L412 | Sub-step (b) of `homOfLocalCompat`; blueprint describes the step but not this wrapper |
| `Scheme.Modules.topSectionToHom_app` | L425 | Companion `simp`-lemma for `topSectionToHom` |

None are suspicious. All are clearly helper constructions feeding the blueprint-referenced declarations. The blueprint mentions `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` as the passage; `topSectionToHom` wraps `presheafHomSectionsEquiv` and is a reasonable extracted helper. The presheaf-level `dualUnitIsoGen` / `unitDualSectionEquiv` / `presheafDualUnitIso` chain is a sensible decomposition of the `dual_unit_iso` build.

---

## Blueprint adequacy for this file

**Coverage:** 5 of 5 blueprint-referenced declarations have corresponding `\lean{...}` blocks.
(Listed: `dual_restrict_iso`, `dual_unit_iso`, `dual_isLocallyTrivial`, `homLocalSection`, `homOfLocalCompat`.) 5 additional Lean declarations are helpers without `\lean{...}` references — all acceptable.

**Proof-sketch depth:**
- `lem:dual_restrict_iso`: **adequate**. The blueprint provides a detailed two-leg (A/B) proof analysis with explicit Mathlib references, warnings about non-applicability of `overSliceSheafEquiv`, and an alternative route. The Step 4 sorry is a genuine open build the blueprint correctly identifies as non-trivial, not a blueprint gap.
- `lem:dual_unit_iso`: **adequate**. Blueprint describes evaluation-at-1 + sheafification clearly.
- `lem:dual_isLocallyTrivial`: **adequate**. Blueprint describes the three-step chain precisely; the Lean faithfully implements it.
- `lem:scheme_modules_hom_local_section`: **silent on proof sketch** (no `\begin{proof}...\end{proof}` block). The lemma statement is detailed enough to guide formalization; the Lean implementation is axiom-clean and correctly implements the described naturality. Not a critical gap.
- `lem:sheafofmodules_hom_of_local_compat` sub-step (a): **under-specified / incorrect assumption**. The blueprint at lines 5801–5825 describes the cocycle bridge and says the two types are "propositionally equal but not definitionally equal" — which is what makes the HEq bridge work. This claim is **incorrect for the actual Lean signature** (`Scheme.Modules.pullback` gives only-isomorphic objects). The blueprint's description of sub-step (a) does NOT provide a concrete bridge for the actual case where the types are only isomorphic. It says "the route-difference collapses by `Subsingleton.elim`" — this handles the thin-poset morphism comparison but does NOT address how to extract sectionwise equalities from an HEq between pullback-sheaf images. The blueprint here is adequately written for a different (propositionally-equal-types) form of `hf`, not the form in the Lean code.
- `lem:sheafofmodules_hom_of_local_compat` sub-steps (b) and (c): **adequate**. Sub-step (b) (top-section-to-morphism conversion) and sub-step (c) (sectionwise linearity via separatedness) are correctly described and sufficient to guide formalization once (a) is resolved.

**Hint precision:** precise for all but `lem:scheme_modules_hom_local_section` (no proof block, but statement is self-describing). For `homOfLocalCompat`: the `\lean{...}` hint is correct, but the proof description contains an incorrect assumption (propositional equality of types) that does not match the actual Lean form of `hf`.

**Generality:** matches need.

**Recommended chapter-side actions for a blueprint-writing subagent:**
1. **Critical**: In the proof of `lem:sheafofmodules_hom_of_local_compat`, sub-step (a) (lines 5801–5825): revise the claim that the types are "propositionally equal but not definitionally equal." The correct statement depends on whether the fix uses (i) a sectionwise form of `hf` or (ii) `restrictFunctor` with propositional equality. The blueprint should:
   - Document the precise Lean form of the `hf` hypothesis (after the mathematician fixes the signature),
   - Provide a concrete bridge: explain how the sectionwise equality of the middle terms `(f i).val.app ..` and `(f j).val.app ..` is extracted from `hf` (whatever the new form), conjugated through the `homLocalSection` eqToHom's, and identified by `Subsingleton.elim`.
2. **Minor**: Add a `\begin{proof}...\end{proof}` block to `lem:scheme_modules_hom_local_section` (currently statement-only). The Lean proof is now available as a reference.

---

## Severity summary

**must-fix-this-iter:**

1. **`homOfLocalCompat` `hf` signature — unconsumable HEq**: The `hf` parameter uses `HEq` between `Scheme.Modules.pullback`-images whose source/target objects are only isomorphic (not propositionally equal), making every standard HEq-elimination inapplicable. The proof of the `IsCompatible` condition (sub-step (a)) is blocked at `sorry` (line 565) by this obstacle. The signature must be re-phrased — sectionwise or via a form with propositional equality — but it is treated as PROTECTED and requires mathematician intervention. This is the critical blocker for the entire `homOfLocalCompat` proof.

2. **Blueprint sub-step (a) under-specification**: The blueprint proof of `lem:sheafofmodules_hom_of_local_compat` at lines 5801–5825 claims the types in the `HEq` are "propositionally equal but not definitionally equal" — incorrect for the Lean implementation. The blueprint does not provide a bridge for the actual Lean form. A blueprint-writing subagent should revise this section once the mathematician fixes the `hf` signature.

**major:**

3. **Internal inconsistency in `homOfLocalCompat` Lean file**: The docstring (lines 432–449) says the source/target types ARE propositionally equal via `restrictFunctorComp`, but the proof body comment (lines 547–564) says they are NOT (only isomorphic). The proof body analysis is correct; the docstring reflects an outdated design intent. The docstring should be corrected to match the actual situation.

**minor:**

4. `lem:scheme_modules_hom_local_section` has no proof block in the blueprint (statement-only). The Lean proof is axiom-clean and available. Worth adding a proof sketch for future reference.

**Overall verdict:** `homOfLocalCompat` is blocked by an unconsumable `hf` signature that does not match the blueprint's bridge assumption; the blueprint's description of sub-step (a) is inadequate for the actual Lean form. 5 declarations checked, 2 sorries in `homOfLocalCompat` (one fundamental, one transitively gated), 1 sorry in `dual_restrict_iso` (genuine open build, blueprint-adequate).
