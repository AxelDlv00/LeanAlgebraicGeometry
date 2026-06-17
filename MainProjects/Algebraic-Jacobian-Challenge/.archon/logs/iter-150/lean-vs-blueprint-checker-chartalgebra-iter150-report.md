# Lean ↔ Blueprint Check Report

## Slug

chartalgebra-iter150

## Iteration

150

## Files audited

- Lean: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` (702 LOC)
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (chart-algebra sub-section
  L1835–2344; chapter has 2361 LOC overall)

Five `\lean{...}` blocks target this file (one is the algebra-IsPushout, one is
KDM, one is the per-chart wrapper, one is the constants lemma, one is the lift).
Two further `\lean{...}` blocks (S3.\* labels at L1993/2017/2042/2069) target the
sister file `ChartAlgebraS3.lean` and are out of scope here.

## Per-declaration

### `\lean{AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product}` (lem:chart_algebra_isPushout_of_affine_product, L1842)

- **Lean target exists**: yes (L88).
- **Signature matches**: yes. The Lean signature stops at the algebra layer
  (`Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂)`); the blueprint's prose
  carries a scheme-level wrapper around the same algebra-level claim and
  explicitly authorises the `inferInstance` closure in its `% NOTE (iter-146
  review)` block at L1851–1859. No mismatch.
- **Proof follows sketch**: yes (concession path). The chapter sketches a
  three-step `pullbackSpecIso` → `isPullback_SpecMap_of_isPushout` →
  `CommRingCat.isPushout_iff_isPushout` chain, but the iter-146 NOTE inside the
  lemma block explicitly endorses `inferInstance` after re-enabling
  `Algebra.TensorProduct.rightAlgebra`. The Lean proof at L91–92 takes that path.
  The structural narrative is preserved (the three-step chain remains the
  "honest derivation at the scheme level" per the NOTE).
- **notes**: the `attribute [local instance] Algebra.TensorProduct.rightAlgebra`
  at L78 is the load-bearing instance-resolution hint that lets the
  `inferInstance` path close; the blueprint NOTE at L1853 calls this out.

### `\lean{AlgebraicGeometry.GrpObj.df_zero_factors_through_constant_on_chart}` (lem:chart_algebra_df_zero_factors_through_constant_on_chart, L1891)

- **Lean target exists**: yes (L416).
- **Signature matches**: **partial — the Lean signature is structurally weaker
  than the blueprint prose**. The chapter pins the lemma's content as: "given
  $f : C \to A$ with $df = 0$, a chart pair $(W = \Spec B, V = \Spec R)$ with
  ring map $f^{\sharp} : B \to R$ and standard-smooth chart data, conclude
  $f^{\sharp}(b) \in \operatorname{range}(\mathtt{algebraMap}\,k\,R)$ for every
  $b \in B$". The Lean signature drops $A$, $f$, $f^{\sharp}$, $R$, the chart
  pair $(W, V)$, and the differential hypothesis $df = 0$; it carries only $B$
  with $hDb : D_B b = 0$ and concludes $b \in (\mathtt{algebraMap}\,k\,B)$.range.
  The four C-side typeclasses (`IsProper`, `Smooth`, `IsReduced`,
  `GeometricallyIrreducible`) are present but unused in the body (which is a
  one-line delegate to KDM at L434). The blueprint NOTE at L1896–1916
  acknowledges this disposition and pins it as an iter-149+ refinement target.
- **Proof follows sketch**: no. The blueprint sketches a 5-step closure
  (chart-level translation of $df = 0$, extension to all $b \in B$, 2-chart
  Čech Mayer–Vietoris promotion, ring-side KDM extraction, integrally-closed-
  constants closure). The Lean body executes only Step 4 (KDM delegation);
  Steps 1–3 + 5 are not exercised because the signature does not carry the
  upstream chart-algebra data.
- **notes**:
  - Directive-flagged item: iter-148 flagged the four C-side typeclasses as
    decorative. Iter-149 added `[CharZero k]` and
    `[Algebra.IsStandardSmoothOfRelativeDimension n k B]` (the KDM premises)
    and propagated `(n := n)` to the KDM call. **It did NOT touch the four
    C-side typeclasses**, which remain decorative — the body still consumes
    none of them. The iter-149 inflation cleaned up the KDM-side hypotheses
    but did NOT close the iter-148-flagged C-side decorative-typeclass issue.
  - The blueprint NOTE at L1909–1916 records the planned iter-149+ inflation
    (`(A, f : C → A, df = dg, W, V, f^{\sharp})`) as still outstanding.

### `\lean{AlgebraicGeometry.constants_integral_over_base_field}` (lem:constants_integral_over_base_field, L2093)

- **Lean target exists**: yes (L473).
- **Signature matches**: yes. Lean concludes
  `RingHom.range ((X ↘ Spec (.of k)).appTop.hom) = ⊤`; blueprint conclusion is
  `Γ(X, O_X) = range(algebraMap k Γ(X, O_X))`. These are equivalent (via
  `RingHom.range_eq_top` and the `appTop`/`ΓSpecIso` algebraMap identification
  at L538–543), and the Lean body explicitly converts between them. The
  `[IsReduced X]` hypothesis is documented in the blueprint NOTE at L2098–2106
  as a Mathlib-`b80f227`-gap workaround. OK.
- **Proof follows sketch**: partial (intentional fork between paths a + b).
  The blueprint commits the in-tree Lean route to path (b) "SMART PROOF" at the
  NOTE L2142–2169, reducing to the conjunction
  `IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ` and discharging via
  `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`. The Lean body at
  L588–656 executes exactly this reduction; substep (1)–(2) of the iter-145
  recipe (irreducibility + reducedness → integral; properness → field +
  finite appTop) is closed at L482–495; the path-(b) skeleton at L531–656
  routes through `algebraMap k Γ`, splits into hPI ∧ hSep, and discharges via
  Mathlib's `surjective_algebraMap_of_isSeparable` at L654–655.
- **notes**:
  - The hPI branch (L592–617) remains `sorry` per directive expectation. Its
    inline 5-step chain (L594–616) matches the chapter's (S3.pi.1) + (S3.pi.2)
    decomposition (L2037–2091): geom-irr → IrreducibleSpace X_{\bar k} (step
    (i)); smooth base change → IsReduced X_{\bar k} (step (ii));
    IsIntegral X_{\bar k} ⇒ Γ_{\bar k} domain (step (iii)); (S3.pi.1)
    `Gamma_baseChange_iso_tensor_of_proper` to identify Γ ⊗_k \bar k (step
    (iv)); (S3.pi.2) `IsPurelyInseparable.of_unique_minPrime_baseChange` to
    extract pure inseparability (step (v)). Chapter ↔ Lean alignment is
    correct on the (S3.pi.\*) decomposition.
  - The hSep branch (L618–651) is project-internally closed via the (S3.sep.1)
    + (S3.sep.2) chain in `ChartAlgebraS3.lean` (delegated via
    `isGeometricallyReduced_Gamma_of_smooth` and
    `IsSeparable.of_isGeometricallyReduced_of_finite`). The Module.Finite
    bridge at L639–649 (composing `Iso.commRingCatIsoToRingEquiv` for the
    `ΓSpecIso` half with `_hAppTopFinite` for the `appTop` half) is a real
    piece of structural work, but is bounded and self-contained.

### `\lean{AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero}` (lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero, L2228)

- **Lean target exists**: yes (L256).
- **Signature matches**: yes. The chapter prose authorises both
  `[CharZero k]` (path (p2)) and standard-smooth-of-relative-dimension-`n` as
  the (BR.1) signature inflation; the Lean signature at L257–260 takes both as
  bound parameters. The `{n : ℕ}` and `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`
  binders match the blueprint's (BR.1) bullet at L2246 verbatim. The conclusion
  `b ∈ (algebraMap k B).range` matches the chapter's
  `b ∈ \operatorname{range}(\mathtt{algebraMap}\,k\,B)`.
- **Proof follows sketch**: **no — the Lean is following a strategy the
  blueprint does not describe**. The chapter's only structured (p2) closure
  path is the (BR.1)–(BR.5) chain (L2244–2252): (BR.1) signature inflation,
  (BR.2) `Algebra.IsStandardSmooth.free_kaehlerDifferential` basis,
  (BR.3) coefficient-derivation extraction `∂_i`, (BR.4) `Differential B`
  instance per `∂_i`, (BR.5) `Differential.ContainConstants` instance for `∂_i`
  in CharZero. The Lean body at L267–388 instead executes a **HYBRID (C)
  MvPolynomial-side joint-kernel-collapse + functoriality-transfer** approach:
    - (BR.2) basis selection at L273–274: matches blueprint.
    - (BR.3) coordinate-derivation extraction at L283–289: matches blueprint
      structurally.
    - (BR.4) `Differential B` instance: **NOT** registered (L290–296
      acknowledges "we keep this as an explicit `let` rather than registering
      it globally").
    - (BR.5) the blueprint's `Differential.ContainConstants`-instance route is
      **abandoned**. The Lean lifts `b` to `bTilde` via the SubmersivePresentation
      surjection (L340–348), establishes the functoriality
      `KaehlerDifferential.map_D` reduction (L351–360), and concludes with a
      `sorry` at L388 for the transfer step (modifying `bTilde` to land
      `α : P.Ring` with `algebraMap α = b` and `D_A α = 0`).
    - The MvPolynomial FREE-CASE machinery at L117–225 (the four `_finsupp_*`
      / `_mvPoly_*` private lemmas) is the helper investment supporting this
      alternative route; **none of it is referenced by the blueprint
      (BR.1)–(BR.5) sub-block**.
- **notes**:
  - Directive-flagged item: "the residual structured sorry concentrates on the
    transfer step (`α : P.Ring` with `algebraMap P.Ring B α = b` and
    `D_A α = 0`)". Verified: the sorry at L388 is exactly this transfer-step
    gap (L361–387 documents the modification step needed via the
    `KaehlerDifferential.ker_map_of_surjective` description; ~30 LOC of
    `Submodule.map`/`Finsupp.sum` chasing called out as iter-151+).
  - The Lean comments (L297–337) are honest about the divergence: the comment
    explicitly names this "HYBRID part (C) approach" and contrasts it with the
    blueprint's `Differential.ContainConstants` route. But the chapter has
    not absorbed this strategy switch — the (BR.1)–(BR.5) blueprint decomposition
    is still the only structured (p2) closure path in the chapter.

### `\lean{AlgebraicGeometry.Scheme.Over.ext_of_diff_zero}` (lem:Scheme_Over_ext_of_diff_zero, L2289)

- **Lean target exists**: yes (L686).
- **Signature matches**: **partial — the Lean signature is structurally weaker
  than the blueprint prose**. The chapter's statement (L2318–2323) pins the
  hypotheses to (i) `df = dg` as morphisms of $\mathcal O_C$-modules, (ii)
  agreement of $f, g$ on a non-empty open $U$, with $C$ a smooth proper
  geometrically irreducible curve of genus 0 and $A$ a smooth proper
  geometrically irreducible group scheme. The Lean signature drops `df = dg`,
  the `genus 0` + `smooth proper` curve hypotheses, and the `smooth proper
  geometrically irreducible group scheme` hypothesis on $A$; it keeps only
  `[IsSeparated A.hom]`, `[IsReduced C.left]`, `[GeometricallyIrreducible C.hom]`
  and the `eqOnOpen` data. The blueprint NOTE at L2294–2317 acknowledges this
  as a thin renaming of `Rigidity.ext_of_eqOnOpen` and pins the substantive
  `df = dg` inflation as iter-147+/iter-148+ work, still outstanding at iter-150.
- **Proof follows sketch**: no. The chapter sketches a three-step closure
  (chart-algebra ($\beta$) reduction to a single difference morphism $h$ with
  $dh = 0$; chart-by-chart per-chart helper application; identify constant
  value via agreement on $U$). The Lean body at L696 is a one-line delegate to
  `Scheme.Over.ext_of_eqOnOpen`, which is Step 3 only — Steps 1–2 are not
  exercised because the signature does not carry $df = dg$.
- **notes**: parallel disposition to the `df_zero_factors_through_constant_on_chart`
  case — both are blueprint-acknowledged thin-wrapper degenerations pending
  later iters' substantive inflation.

## Red flags

### Placeholder / suspect bodies

- `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` (L256, body L267–388,
  `sorry` at L388): the forward-direction sorry on the load-bearing chart-algebra
  KDM lemma. Per the rubric, placeholder bodies on declarations the blueprint
  claims are substantive are must-fix-this-iter. The Lean comment at L361–387
  is honest about the gap and documents the transfer-step closure path, but the
  sorry is on a substantive claim, not a helper.
- `constants_integral_over_base_field` (L473, body L479–655, `sorry` at L617):
  the `hPI` (pure inseparability) branch of the path-(b) closure. Blueprint-
  documented as the (S3.pi.1) + (S3.pi.2) chain bridge; project-internal
  closure depends on the bodies of those S3 lemmas in `ChartAlgebraS3.lean`
  (Lane 1, not this iteration). The structured sorry is correctly localised
  per the directive but is still a sorry on a load-bearing branch.

### Excuse-comments

None. All `% NOTE` blocks in the chapter and inline Lean comments are
disposition documents (recording iter-146/147/148/149/150 state changes) rather
than excuse-for-wrong-code; they correctly name the gap, the closure path, and
the iter horizon.

### Axioms / Classical.choice on non-trivial claims

None.

## Unreferenced declarations (informational)

- `_finsupp_sub_single_eq_of_one_le` (L117) — private helper for the MvPolynomial
  pderiv coefficient formula. **Not blueprint-referenced**, but the blueprint
  does not describe the MvPolynomial-helpers route at all (see the KDM finding
  above). This is a helper-style declaration that exists to support a proof
  strategy the chapter does not document.
- `_mvPoly_coeff_pderiv_at_shifted` (L133) — private; same disposition.
- `_mvPoly_mem_range_C_of_pderiv_eq_zero` (L175) — private; same disposition.
- `_mvPoly_mem_range_C_of_D_eq_zero` (L215) — private; same disposition.
  This is the (BR.5) FREE-CASE step of the strategy actually being executed,
  and would be a natural candidate for promotion to a first-class blueprint
  block under a `(BR.5')` MvPolynomial sub-section if the chapter pivots to
  document the HYBRID (C) route.

All five private helpers are reasonable as helpers; the issue is not their
existence but that the chapter has not been updated to describe the proof
strategy they support.

## Blueprint adequacy for this file

- **Coverage**: 5 / 9 Lean declarations have `\lean{...}` blocks (the four
  substantive theorems + KDM). 4 unreferenced declarations are all private
  helpers for the MvPolynomial-transfer route. **All substantive declarations
  are covered by `\lean{...}` references.**
- **Proof-sketch depth**: **under-specified** for KDM. The chapter's only
  structured (p2) closure is (BR.1)–(BR.5) via `Differential.ContainConstants`;
  the Lean is following a MvPolynomial-side joint-kernel collapse +
  SubmersivePresentation lift + functoriality reduction route the chapter does
  not describe. Adequate for the other four blocks.
- **Hint precision**: precise. All five `\lean{...}` hints name the correct
  fully-qualified Lean declaration; signature precision is good (KDM and
  constants_integral are tight on the binders the prose pins).
- **Generality**: matches need. The KDM signature's `{n : ℕ}` +
  `[Algebra.IsStandardSmoothOfRelativeDimension n k B]` exactly tracks the
  (BR.1) signature inflation the chapter authorises.
- **Recommended chapter-side actions**:
  - Add a `(BR.5')` sub-block (or pivot (BR.4)–(BR.5)) to document the
    MvPolynomial joint-kernel-collapse + `KaehlerDifferential.map_D` +
    `KaehlerDifferential.ker_map_of_surjective` transfer route that the iter-150
    Lean actually executes. The Lean comments at L297–337 of `ChartAlgebra.lean`
    are a good seed for the prose. As long as the chapter only documents the
    `Differential.ContainConstants` (BR.5) route, the project's MvPolynomial-
    side investment (the four `_mvPoly_*` private lemmas) is blueprint-
    unanchored.
  - Resolve the C-side decorative-typeclass disposition on
    `df_zero_factors_through_constant_on_chart` and `ext_of_diff_zero`: either
    inflate the Lean signatures per the iter-149+/iter-148+ refinement plans
    in the blueprint NOTEs, or formalise in the chapter that the load-bearing
    Lean signature is the slim KDM-delegate / `eqOnOpen`-renamed form (which
    would change the chapter's statement blocks substantively, not just add a
    NOTE).

## Severity summary

- **must-fix-this-iter**:
  - `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` body `sorry` at
    L388 — placeholder body on a substantive blueprint claim (rubric: "`:= sorry`
    on a declaration the blueprint claims is substantive"). The transfer-step
    closure is the dominant outstanding (p2) gap; iter-151+ continuation
    expected per the iter-150 deposit framing.
  - **Blueprint adequacy failure (KDM)**: the chapter does not document the
    HYBRID (C) MvPolynomial-transfer proof strategy the Lean is actually
    following. The (BR.1)–(BR.5) blueprint decomposition assumes the
    `Differential.ContainConstants` route; the Lean has pivoted away. Per the
    rubric this is "chapter is so under-specified that a prover could not
    have formalized this file correctly from prose alone" — strictly, the
    chapter still gives a path, just not the one the Lean took. This is
    arguably between major and must-fix; classifying as must-fix because the
    iter-150 ~190 LOC of MvPolynomial helpers + SubmersivePresentation
    plumbing have no anchor in the chapter, and the residual sorry's closure
    path is described in Lean comments rather than blueprint prose.

- **major**:
  - `df_zero_factors_through_constant_on_chart` signature mismatch (Lean drops
    $A$, $f$, $df = 0$, $W$, $V$, $f^{\sharp}$, $R$ from the chapter's
    statement; body is a one-line KDM delegate). Blueprint NOTE acknowledges
    and pins as iter-149+ refinement. Iter-149 added KDM-side binders but did
    not address the C-side decorative-typeclass issue iter-148 flagged.
  - `ext_of_diff_zero` signature mismatch (Lean drops `df = dg`, genus 0 +
    smooth proper hypotheses; body is a one-line `ext_of_eqOnOpen` delegate).
    Blueprint NOTE acknowledges and pins as iter-148+ refinement, still
    outstanding at iter-150.
  - `constants_integral_over_base_field` `hPI` branch `sorry` at L617 — a
    `sorry` on a load-bearing branch, with project-internal closure depending
    on (S3.pi.1) + (S3.pi.2) bodies in `ChartAlgebraS3.lean`. Inline 5-step
    chain matches the chapter's (S3.pi.\*) decomposition.

- **minor**:
  - The four MvPolynomial private helpers at L117–225 are
    blueprint-unanchored. Not a defect of the Lean (they're scoped `private`
    and helper-style) but a symptom of the under-specification at the KDM
    block.

**Overall verdict**: The chart-algebra (α) lemma is well-aligned; the constants
lemma matches the chapter's (S3.\*) decomposition and is correctly localising
its residual sorry to (S3.pi.\*); but the KDM lemma has both a substantive sorry
and a chapter ↔ Lean strategy divergence (MvPolynomial-transfer vs.
`Differential.ContainConstants`), and the two thin-wrapper degenerations
(`df_zero_factors_through_constant_on_chart`, `ext_of_diff_zero`) still carry
the iter-148/149-flagged decorative-typeclass / signature-inflation gaps —
must-fix-this-iter on KDM closure or blueprint refresh; major on the two
delegation lemmas pending substantive signature inflation.
