# Lean ↔ Blueprint Check Report

## Slug
tensorobj256

## Iteration
256

## Files audited
- Lean: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

---

## Per-declaration (priority declarations from directive)

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict}` (chapter: `\lem:pullback_tensor_map_basechange`)

- **Lean target exists**: yes — line 2138 of `TensorObjSubstrate.lean`.
- **Signature matches**: **no** — critical content mismatch between blueprint statement and Lean signature (see detail below).
- **Proof follows sketch**: **no** — the Lean proof body is `:= sorry` (scaffolded, not proved). Additionally the blueprint proof sketch is under-specified and partially misleading for the genuine proof route (see §Blueprint adequacy below).
- **notes**:

  **Statement divergence — general composition coherence vs. base-change square.**

  *Lean signature* (line 2138–2146):
  ```lean
  lemma pullbackTensorMap_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
      (M N : X.Modules) :
      pullbackTensorMap (h ≫ f) M N =
        (Scheme.Modules.pullbackComp h f).inv.app (tensorObj M N) ≫
        (Scheme.Modules.pullback h).map (pullbackTensorMap f M N) ≫
        pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
          ((Scheme.Modules.pullback f).obj N) ≫
        (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
          ((Scheme.Modules.pullbackComp h f).app N)).hom := by
    sorry
  ```
  This is a **general composition coherence** for any two composable scheme morphisms
  `h : Z ⟶ Y`, `f : Y ⟶ X`: it says `δ_sheaf(h∘f)` factors as
  `pullbackComp.inv ≫ (pullback h).map(δ_sheaf(f)) ≫ δ_sheaf(h) ≫ tensorObjIsoOfIso(pullbackComp)(pullbackComp)`.

  *Blueprint statement* (`\lem:pullback_tensor_map_basechange`, lines 3857–3896):
  The blueprint describes a **base-change square specialization**: for `f : Y → X`,
  an open `U ⊆ X`, open immersions `j : U ↪ X` and `j' : f⁻¹U ↪ Y`, and
  `g : f⁻¹U → U` the restriction of `f` with `f ∘ j' = j ∘ g`, the lemma
  asserts that `(j')^*(δ^f_sheaf(M,N))` equals `δ^g_sheaf(j^*M, j^*N)` through the
  pullback pseudofunctoriality isomorphism `pullbackComp`.

  These are **mathematically different statements**:
  - The Lean asserts the general composition coherence for ANY `h, f`.
  - The blueprint asserts only the specialization to the base-change-square setting
    (where `h = j'` is an open immersion and the square commutes on the nose).

  The Lean docstring (lines 2128–2131) acknowledges this: "The base-change-square form
  of the blueprint ... is the specialisation `h := j'`, `f`, applied to the two
  factorisations `j' ≫ f = g ≫ j` ... the displayed identity follows by equating the
  two instances of this coherence." So the Lean proves the STRONGER general form, from
  which the blueprint's weaker form follows. However the `\lean{...}` tag names the
  decl for the base-change square, which is stated differently from what the decl
  actually says.

  **Proof body**: `:= sorry`. Correctly the blueprint proof block does NOT have `\leanok`.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_natural}` (chapter: `\lem:pullback_tensor_map_natural`, D1′)

- **Lean target exists**: yes — line 2007.
- **Signature matches**: yes. The blueprint statement (naturality of `δ_sheaf` in both module arguments, commuting square for morphisms `a : M → M'`, `b : N → N'`) matches the Lean signature precisely.
- **Proof follows sketch**: yes / partial. The Lean proof (lines 2007–2115) is a four-square pasting, matching the blueprint's description: Square 2 uses `δ_natural` with a canonical-form ascription (`show … from`), Squares 3/4 use the helpers `sheafifyTensorUnitIso_hom_natural` / `pullbackValIso_hom_natural`.
- **notes**:
  - Lean proof is **sorry-free** (confirmed by grep: no `sorry` in lines 2007–2115).
  - The blueprint's STATEMENT block has `\leanok` (line 3289). ✓
  - The blueprint's PROOF block does **NOT** have `\leanok` (proof ends at line 3359,
    no `\leanok` inside that block). This is a `sync_leanok` gap: D1′ is axiom-clean
    and sorry-free in Lean but its proof block is not yet marked closed in the blueprint.
    **Major**: should be added by sync_leanok; the plan agent should note this.

---

### `\lean{AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_unit_isIso}` (chapter: `\lem:pullback_tensor_iso_unit`, D2′)

- **Lean target exists**: yes — line 1851.
- **Signature matches**: yes. The blueprint states `IsIso (pullbackTensorMap f 𝒪_X 𝒪_X)` for any `f : Y → X`; the Lean signature is identical.
- **Proof follows sketch**: yes. The Lean proof (lines 1851–1855) is a one-liner chaining `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` ← `isIso_sheafifyEta_of_unitSquare` ← `pullbackEtaUnitSquare`, matching the blueprint's described route.
- **notes**:
  - Lean proof is **sorry-free** (confirmed by grep: no `sorry` in lines 1851–1855).
  - The blueprint's STATEMENT block has `\leanok` (line 3434). ✓
  - The blueprint's PROOF block does **NOT** have `\leanok` (proof ends at line 3483,
    no `\leanok` inside that block). Same `sync_leanok` gap as D1′.
    **Major**: D2′ is axiom-clean and sorry-free but not yet proof-marked in the chapter.

---

## Red flags

### Placeholder / suspect bodies

- `Scheme.Modules.pullbackTensorMap_restrict` at line 2138–2188: body is `:= sorry`. The blueprint's `\leanok` in the STATEMENT block is CORRECT (declaration exists), and the proof block correctly lacks `\leanok`. But the sorry is active: this is the scaffolded D3′ sub-task outstanding for iter-257.
- `Scheme.Modules.exists_tensorObj_inverse` at line 693–715: body is `:= sorry`. Known tracked sorry, not a new finding.

### Excuse-comments / explanatory typed-sorry comments

- Line 2167: the Lean body contains a detailed explanation of WHY the proof is sorry rather than a proof body:
  ```
  -- this typed `sorry` rather than forcing a non-applicable device.
  ```
  This is appropriate (the prover correctly scaffolded the decl rather than applying a failing approach), but it means D3′ is an unfinished obligation the plan agent must track for iter-257.

---

## Unreferenced declarations (informational)

The file has multiple helpers that are not directly `\lean{...}`-pinned in the blueprint but feed the `\lean{}`-pinned decls:
- `isIso_sheafify_tensorHom_pullbackValIso` (private, line ~1327) — internal helper.
- `sheafifyTensorUnitIso_hom_eq` / `sheafifyTensorUnitIso_hom_eq'` (private, lines 1860–1898) — tscmp254 pin helpers, referenced in proof comments.
- `pullbackObjUnitToUnitIso` + `pullbackObjUnitToUnitIso_hom` (lines 1036–1046) — helper lemma; feeds `pullbackUnitIso`.
- `isIso_pbu_of_final` (private, line 1028) — TC-resolution workaround.
- `pullback0`, `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction` (section `PullbackLanDecomposition`) — labelled off-path (D1, iter-243 pivot); blueprint has `lem:pullback_lan_decomposition` pinning `pullbackLanDecomposition` which IS in the file.
- `W_of_isIso_sheafification` (private, line 1376) — converse lemma; no blueprint pin, but feeds D2′ route.

None of these are substantive mis-orphans; the off-path section is correctly labelled in both the Lean file and the blueprint.

---

## Blueprint adequacy for this file

### The `pullbackTensorMap_restrict` proof sketch — principal adequacy finding

**This is the must-fix-this-iter finding.**

The directive reports the prover's verdict: the blueprint proof sketch prescribes "mirror `pullbackObjUnitToUnit_comp`" via an adjunction-transpose argument, but `pullbackTensorMap` is NOT an adjunction transpose (it is a hand-built 4-fold composite), so the mirror recipe cannot start.

Having read the blueprint proof text for `\lem:pullback_tensor_map_basechange` (lines 3869–3898) in full, the picture is as follows:

1. **"Same mate calculus" phrase** (line ~3869):
   > "This is the tensorator analog of the unit-comparison composition coherence
   > `lem:pullbackObjUnitToUnit_comp`, and is proved by the same mate calculus rather
   > than on sections."

   This is **misleading**. The proof of `pullbackObjUnitToUnit_comp` opens with
   `(pullbackPushforwardAdjunction (h≫f)).homEquiv.injective` — transposing through
   `homEquiv` — because `pullbackObjUnitToUnit` IS definitionally an adjunction transpose.
   `pullbackTensorMap` is a hand-built 4-fold composite; it is NOT a transpose, and there
   is no `…homEquiv_pullbackTensorMap` bridge. The Lean file's own comment (lines 2158–2167)
   confirms: "hence the mirror's very first move (`(pullbackPushforwardAdjunction (h≫f)).homEquiv.injective`)
   leaves an un-evaluable transpose of a concrete composite and stalls."
   The "same mate calculus" phrase therefore does prescribe a failed approach for a prover
   who follows the unit-analog reference.

2. **`comp_δ` route correctly named** (lines 3878–3888):
   The blueprint then pivots to `Functor.OplaxMonoidal.comp_δ` and
   `conjugateEquiv_pullbackComp_inv`, which ARE correct tools. However:

   - The sketch describes applying them to the **two factorisations** of `f∘j' = j∘g`
     (the base-change-square setting), not to the **general composition** `h∘f`. So it
     describes a proof of the base-change square statement, while the Lean proves the
     general composition coherence.
   - The sketch says "applies this to the two factorisations ... identifies the two
     restricted comparisons. The restriction along the open immersion `j'` is the
     strong-monoidal restriction functor of `lem:tensorobj_restrict_iso`, so it carries
     `δ^f_sheaf` to its value on the restricted modules without introducing a defect."
     This sentence describes proving the BASE-CHANGE SQUARE form (using the
     strong-monoidal property of open-immersion restriction), NOT the general
     composition coherence that the Lean actually targets.

3. **Two absent project sub-lemmas unmentioned**:
   The Lean body comment (lines 2178–2186) identifies the two genuine missing
   ingredients for the general composition coherence:
   - **Sq1**: Composition coherence of `SheafOfModules.sheafificationCompPullback`
     across `h∘f` — a project sub-lemma (~40–80 LOC, Mathlib-absent).
   - **Sq4**: Composition coherence of `pullbackValIso` across `h∘f` —
     a second project sub-lemma (~40–80 LOC, Mathlib-absent).
   Neither is mentioned in the blueprint proof sketch, so a prover reading only the
   blueprint would not know these are required.

4. **The `comp_δ` step itself requires ring-map reconciliation** (Sq2 ring-map):
   The sketch mentions `PresheafOfModules.pullbackComp` but doesn't say that applying
   `comp_δ` requires identifying `pullback φ'_{h∘f}` with `pullback φ'_f ⋙ pullback φ'_h`
   via a ring-map reconciliation
   `(toRingCatSheafHom (h≫f)).hom = φ'_f ≫ (Opens.map f.base).op.whiskerLeft φ'_h`.

**Verdict on proof sketch**: The blueprint proof sketch is **Lean-inadequate** in multiple ways:
- It prescribes the misleading "same mate calculus" framing (implies the failed `homEquiv`-transpose approach).
- It targets the base-change-square form while the Lean proves the general composition coherence (or vice versa — either the Lean or the blueprint must be realigned).
- It omits the two required project sub-lemmas (Sq1, Sq4).
- It omits the ring-map reconciliation in the Sq2 step.

**What the chapter must say instead**:
1. State the lemma as the GENERAL COMPOSITION COHERENCE (`h : Z → Y`, `f : Y → X`;
   `δ_sheaf(h∘f) = pullbackComp.inv ≫ (pullback h).map(δ_sheaf(f)) ≫ δ_sheaf(h) ≫ tensorObjIsoOfIso(pullbackComp)(pullbackComp)`),
   and note the base-change-square form follows as a corollary by equating two instances.
2. Replace "same mate calculus as `pullbackObjUnitToUnit_comp`" with an explicit statement that
   the mirror approach FAILS because `pullbackTensorMap` is not an adjunction transpose,
   and specify the four-square comp_δ approach.
3. Name the two absent project sub-lemmas (Sq1: composition coherence of
   `sheafificationCompPullback`; Sq4: composition coherence of `pullbackValIso`) as explicit
   required components.
4. Note the Sq2 ring-map reconciliation step.

### Overall coverage
- **Coverage**: Most `\lean{...}`-pinned declarations in the chapter have correct Lean
  counterparts. The two `sync_leanok` gaps (D1′ and D2′ proof blocks missing `\leanok`)
  are framework issues, not content issues.
- **Proof-sketch depth**: **under-specified** for `pullbackTensorMap_restrict` (D3′).
  All other pinned proof sketches are adequate.
- **Hint precision**: **partially wrong** for `pullbackTensorMap_restrict`: the `\lean{}`
  tag pins the right Lean name, but the mathematical content of the blueprint statement
  (base-change square) diverges from the Lean signature (general composition coherence).
- **Generality**: Lean is MORE GENERAL than blueprint statement (composition coherence vs.
  base-change square). Blueprint adequacy failure: the blueprint should describe the
  general form the Lean actually proves.
- **Recommended chapter-side actions** (must-fix-this-iter):
  1. Update the statement of `\lem:pullback_tensor_map_basechange` to describe the
     GENERAL composition coherence, noting the base-change-square as a corollary.
  2. Remove or qualify "proved by the same mate calculus as
     `\cref{lem:pullbackObjUnitToUnit_comp}`" — add an explicit warning that
     `pullbackTensorMap` is NOT a transpose and the mirror's `homEquiv.injective`
     opening fails.
  3. List Sq1 (sheafificationCompPullback composition coherence) and Sq4
     (pullbackValIso composition coherence) as explicit sub-lemma requirements.
  4. Add the ring-map reconciliation (Sq2) step.
  5. (**Minor, framework**) Trigger sync_leanok to add `\leanok` to the proof blocks
     of `\lem:pullback_tensor_map_natural` (D1′) and `\lem:pullback_tensor_iso_unit` (D2′).

---

## Severity summary

- **must-fix-this-iter**:
  1. `pullbackTensorMap_restrict` (D3′): Blueprint statement describes the base-change
     square specialization; Lean proves the general composition coherence — content mismatch.
  2. `pullbackTensorMap_restrict` (D3′): Blueprint proof sketch prescribes the "same mate
     calculus" framing (implies the disproven `homEquiv`-transpose mirror approach), omits
     the two required project sub-lemmas (Sq1, Sq4), and omits the ring-map reconciliation
     (Sq2). Blueprint inadequate to guide correct formalization.

- **major**:
  1. D1′ (`pullbackTensorMap_natural`): proof block missing `\leanok` despite sorry-free Lean
     proof — sync_leanok gap.
  2. D2′ (`pullbackTensorMap_unit_isIso`): proof block missing `\leanok` despite sorry-free
     Lean proof — sync_leanok gap.

- **minor**: none.

**Overall verdict**: D3′ (`pullbackTensorMap_restrict`) is scaffolded with `sorry` at line 2138; the blueprint proof sketch for it is Lean-inadequate (misleading framing + missing sub-lemmas + statement/signature mismatch) and must be corrected this iter before the prover attempts iter-257. D1′ and D2′ are sorry-free and axiom-clean in Lean but their proof blocks lack `\leanok` in the blueprint (sync_leanok gap). 3 declarations checked for the targeted query; 2 must-fix findings, 2 major findings.
