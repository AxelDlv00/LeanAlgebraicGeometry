# Lean ↔ Blueprint Check Report

## Slug
lvb-di261

## Iteration
261

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_restrict_iso}` (chapter: `lem:dual_restrict_iso`, blueprint L5656)
- **Lean target exists**: yes — `def dual_restrict_iso` at DualInverse.lean:416
- **Signature matches**: yes — `(f : Y ⟶ X) [IsOpenImmersion f] (M : X.Modules) : (dual M).restrict f ≅ dual (M.restrict f)`; matches the blueprint's `(dual M)|_f ≅ dual(M|_f)` for an open immersion
- **Proof follows sketch**: partial — Steps 1–3 (restrictFunctorIsoPullback, sheafificationCompPullback, mapIso) + H1 (pushforwardPushforwardAdj + leftAdjointUniq) all present and matching the blueprint's H1 rewrite; Step 4 is begun via `PresheafOfModules.isoMk (fun V => sliceDualTransport f M V)` but the isoMk naturality square is a `sorry` (L448), inheriting also 7 sorries from `sliceDualTransport`
- **Notes**: `\leanok` at statement level (L5653) is correct — formalization started. No proof-level `\leanok`, which is correct since the proof contains sorries.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_unit_iso}` (chapter: `lem:dual_unit_iso`, blueprint L5835)
- **Lean target exists**: yes — `def dual_unit_iso` at DualInverse.lean:466
- **Signature matches**: yes — `dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf`, matching the blueprint's `dual O_Y ≅ O_Y`
- **Proof follows sketch**: yes — sheafification of `presheafDualUnitIso` followed by sheafificationAdjunction counit; matches the blueprint's "sheafify the presheaf-level evaluation-at-1 isomorphism"
- **Notes**: axiom-clean; blueprint has `\leanok` on both statement and proof (via `\begin{lemma}\leanok` at L5832), which is correct.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.dual_isLocallyTrivial}` (chapter: `lem:dual_isLocallyTrivial`, blueprint L5870)
- **Lean target exists**: yes — `lemma dual_isLocallyTrivial` at DualInverse.lean:524
- **Signature matches**: yes — `(hL : LineBundle.IsLocallyTrivial L) : LineBundle.IsLocallyTrivial (dual L)`; matches the blueprint exactly
- **Proof follows sketch**: yes — three-step chain `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` matches the blueprint's steps 1–3 (restriction commutes / dualIsoOfIso / dual of unit)
- **Notes**: no direct sorry; inherits from `dual_restrict_iso`. `\leanok` at statement level (L5867) is correct. No proof-level `\leanok`, which is correct given the transitive dependency on `dual_restrict_iso`'s sorry.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homLocalSection}` (chapter: `lem:scheme_modules_hom_local_section`, blueprint L5993)
- **Lean target exists**: yes — `def homLocalSection` at DualInverse.lean:547
- **Signature matches**: yes — presheafHom section manufactured from `f i`, conjugated by eqToHom along `image_preimage_of_le`
- **Proof follows sketch**: yes — eqToHom-conjugation in `app`, thin-poset naturality via `Subsingleton.elim`, matching the blueprint's description precisely
- **Notes**: axiom-clean. `\leanok` at statement level (L5990) correct; no proof-level `\leanok` (proof not closed separately), which is consistent with the proof body being inline in the `def`.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.homOfLocalCompat}` (chapter: `lem:sheafofmodules_hom_of_local_compat`, blueprint L6047)
- **Lean target exists**: yes — `def homOfLocalCompat` at DualInverse.lean:705
- **Signature matches**: partial — the blueprint (L6044–6053) states the overlap condition as "restrictions of f_i and f_j to U_i ∩ U_j agree"; the Lean's `hf` is the **sectionwise** form (eqToHom-conjugated section maps agree at each V ≤ U_i ∩ U_j). This is the iter-254 re-sign; the blueprint body (L6113–6116) explains and endorses the sectionwise form, so the sectionwise signature is correctly motivated — but the lemma's statement block (L6048–6053) omits the sectionwise precision, which could mislead a prover constructing the caller
- **Proof follows sketch**: yes — step (i) glue via presheafHom + existsUnique_gluing + topSectionToHom, step (ii) homMk for linearity, matching the blueprint's two-step description
- **Notes**: axiom-clean (iter-256). `\leanok` at statement level (L6044) correct.

---

## Red flags

### Placeholder / suspect bodies

- `sliceDualTransport` (DualInverse.lean:305–317): 7 typed `sorry` goals for `codomainMap` (leg-B), `naturality`, `invFun`, `map_add'`, `map_smul'`, `left_inv`, `right_inv`. These are work-in-progress for an in-flight construction (route-2 sanctioned iter-261), not excuses or fake bodies. The blueprint acknowledges the build is partial (Step-4 residual). **Not a must-fix by checker rules** (the declaration is genuinely incomplete, not faking completeness).
- `dual_restrict_iso` (DualInverse.lean:448): 1 `sorry` for the isoMk naturality square. Inherits from `sliceDualTransport`. Same assessment.

### Excuse-comments

None found. The in-body commentary documents the construction plan, route analysis, and blocked frictions — appropriate for active development, not excusing wrong code.

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations in DualInverse.lean.

---

## Unreferenced declarations (informational)

Declarations in DualInverse.lean with no `\lean{...}` reference in the blueprint:

| Declaration | Line | Assessment |
|---|---|---|
| `PresheafOfModules.unitDualSectionEquiv` | L79 | Helper for `dualUnitIsoGen`. Acceptable as unlisted helper. |
| `PresheafOfModules.dualUnitIsoGen` | L121 | **Substantive.** Mentioned by name in blueprint proof text at L5775 ("this is exactly the pattern already established for … `dualUnitIsoGen`") but has no `\lean{...}` tag. Should be linked. |
| `AlgebraicGeometry.Scheme.Modules.sliceDualTransport` | L184 | **SUBSTANTIVE — KEY MISSING LINK.** Explicitly named in blueprint proof text at L5757–5783 as the leg-(A) atom; no `\lean{...}` tag exists. See Blueprint adequacy section. |
| `AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso` | L455 | Thin bridge alias (feeds `dual_unit_iso`). Acceptable as helper. |
| `AlgebraicGeometry.Scheme.Modules.topSectionToHom` | L604 | Helper for `homOfLocalCompat`. Acceptable as helper. |
| `AlgebraicGeometry.Scheme.Modules.topSectionToHom_app` | L617 | Helper lemma. Acceptable. |
| `AlgebraicGeometry.Scheme.Modules.image_preimage_of_le` | L628 | Helper lemma (the down-set identity). Named in blueprint at L5771 but without `\lean{...}`. Acceptable but should be tagged for completeness. |

---

## Blueprint adequacy for this file

- **Coverage**: 5/12 Lean declarations have a `\lean{...}` block in the chapter. 7 unreferenced: 5 helpers (acceptable) + 2 substantive (flagged: `sliceDualTransport`, `dualUnitIsoGen`).
- **Proof-sketch depth**: **under-specified** on two points (see major findings 1–4 below). The high-level structure (H1 rewrite, leg A via `opensFunctor` reindex, leg B via ring-iso transport) is correct; the concrete implementation detail and the blocking frictions are not.
- **Hint precision**: **precise** for the 5 declared `\lean{...}` targets (all names match exactly). **Missing** for `sliceDualTransport` (the key intermediate), which makes it impossible to formally link the blueprint to that declaration.
- **Generality**: matches need.

### Major blueprint adequacy failures

**1. Design scope mismatch: `sliceDualTransport` is leg A∘B in Lean, leg A only in blueprint.**

Blueprint (L5757–5778) explicitly says "`sliceDualTransport f M V` is the leg-(A) atom" — the eqToHom-conjugation across `f.opensFunctor`. Then (L5780–5784): "The Step-4 residual is then `PresheafOfModules.isoMk` of the sectionwise composite of (leg A, `sliceDualTransport`) **followed by** (leg B, `restrictScalarsRingIsoDualEquiv`)."

In the Lean, `sliceDualTransport` is **leg A∘B combined** (its docstring says "Leg (A)∘(B)" and its body includes the leg-B `?_` sorry for the codomain ring-iso swap). `dual_restrict_iso` then calls `isoMk (fun V => sliceDualTransport f M V)` with **no separate leg-B** in `isoMk`. These two designs are mathematically equivalent but structurally inconsistent: a reader following the blueprint would expect the `isoMk` call to take a composite `sliceDualTransport ≪≫ restrictScalarsRingIsoDualEquivAsIso ...`, not just `sliceDualTransport` alone.

**2. Concrete implementation mismatch: blueprint says eqToHom-conjugation, Lean uses categorical `.map`.**

Blueprint (L5769): "Concretely, `sliceDualTransport f M V` is the `eqToHom`-conjugation of the slice-Hom components across the open-immersion functor `f.opensFunctor`, transported along the down-set identity `image_preimage_of_le`... this is exactly the pattern already established for `homLocalSection` and `dualUnitIsoGen`."

Lean (DualInverse.lean:277): leg-A uses `(ModuleCat.restrictScalars (β.app (op W.unop.left)).hom).map (φ.app ...)` — **categorical `.map`**, not eqToHom-conjugation. The Lean comment explains: "categorically via `.map` (avoids the `restrictScalars` carrier-instance loss that raw `ModuleCat.ofHom` triggers)." The blueprint's "Concretely" description no longer matches the actual implementation approach.

**3. Missing `\lean{sliceDualTransport}` tag.**

`sliceDualTransport` is the key intermediate decl for `lem:dual_restrict_iso`'s Step-4 residual. It is mentioned by name six times in the blueprint proof text but has no `\lean{...}` tag, breaking the formal Lean–blueprint link for this declaration. A blueprint-doctor or sync_leanok cannot verify or track this decl's sorry state.

**4. Leg-B implementation frictions undocumented.**

Blueprint (L5746–5755) describes leg B as using `restrictScalarsRingIsoDualEquiv` on the Hom-module. The Lean code (L293–305) identifies two concrete frictions that block the intended term `inv (ε (restrictScalars β_W))`:
- **(a) CommRing instance wall**: `restrictScalars_isIso_ε_of_bijective` requires `CommRing R/S`, but the section rings appear as `forget₂ CommRingCat RingCat` images (`↑(Y.ringCatSheaf.obj.obj (op W'))`), whose `CommRing` instance is not synthesized at the RingCat spelling.
- **(b) Unit-section defeq mismatch**: `ε`'s type uses `𝟙_ (ModuleCat _)` but the goal carries the defeq-but-not-syntactic `(restr fV 𝟙_X).obj (op (Over.mk _))` / `(restr V 𝟙_Y).obj W` unit-section forms, so `exact` does not unify them.

A prover working from the blueprint alone would not anticipate these obstacles and could not have closed leg-B without discovering them from scratch.

### Recommended chapter-side actions (for the blueprint-writing subagent)

1. Update the `\begin{proof}` of `lem:dual_restrict_iso` (around L5757–5784) to reflect that **`sliceDualTransport` encodes legs A∘B together** (not leg A alone), and that `dual_restrict_iso` uses it directly in `isoMk` without a separate leg-B step.
2. Replace the "eqToHom-conjugation" concrete description with the actual approach: categorical `.map` via `(ModuleCat.restrictScalars β_W).map (φ.app ...)`, with a note that eqToHom-conjugation (as in `homLocalSection`) would encounter a restrictScalars carrier-instance loss.
3. Add a `\lean{AlgebraicGeometry.Scheme.Modules.sliceDualTransport}` block (statement + proof sketch) inside the proof of `lem:dual_restrict_iso`, or as a standalone lemma. The proof sketch should document the two leg-B frictions (CommRing instance, unit-section defeq).
4. Add a `\lean{PresheafOfModules.dualUnitIsoGen}` tag (mentioned by name in the proof text at L5775).
5. Minor: Update the statement block of `lem:sheafofmodules_hom_of_local_compat` to make the sectionwise overlap hypothesis explicit (currently says "restrictions agree on overlap" without spelling out the eqToHom-conjugated sectionwise form, which is the actual hypothesis of the Lean `hf` parameter).

---

## Severity summary

- **must-fix-this-iter**: 0 (no fake bodies, no wrong signatures on linked decls, no excuse-comments, no unauthorized axioms)
- **major** (4):
  1. Blueprint design scope mismatch: `sliceDualTransport` = leg A in blueprint vs. A∘B in Lean; `dual_restrict_iso`'s `isoMk` call reflects the Lean design not the blueprint's
  2. Blueprint's "Concretely, eqToHom-conjugation" description no longer matches the actual `.map` implementation
  3. Missing `\lean{sliceDualTransport}` tag for the key intermediate decl
  4. Leg-B implementation frictions (CommRing instance, unit-section defeq) not documented in the blueprint
- **minor** (2):
  1. No `\lean{dualUnitIsoGen}` tag (mentioned in blueprint text, not tagged)
  2. No `\lean{image_preimage_of_le}` tag (named in blueprint text at L5771)

**Overall verdict**: The `\lean{...}` hints that exist are all correctly named and the mathematical structure (H1 rewrite → leg A → leg B) is sound, but the blueprint has drifted from the actual Lean implementation in the scope of `sliceDualTransport` and the concrete implementation of leg A; the blueprint-writing subagent should update the proof of `lem:dual_restrict_iso` and add a formal `sliceDualTransport` block.
