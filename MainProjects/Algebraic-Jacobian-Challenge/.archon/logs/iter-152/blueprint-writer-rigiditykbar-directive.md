# Blueprint Writer Directive

## Slug
rigiditykbar-isalgclosed

## Target chapter
blueprint/src/chapters/RigidityKbar.tex

## Strategy context (the slice that matters)
The project committed an architectural pivot: prove rigidity ONLY over an
algebraically closed base field k̄, and descend to a general base field k
downstream. Reason: a prover lane PROVED the chart-algebra core lemma
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` is mathematically FALSE
as a bare `B`-only algebra lemma (counterexamples: B = k×k finite étale, and
B = ℚ(√2) over ℚ — both satisfy every hypothesis yet `ker D ⊋ range(algebraMap)`).
The missing content is "k algebraically closed in B". Adding `[IsAlgClosed k]`
+ `[IsDomain B]` JOINTLY makes it TRUE (the iter-151 NOTE that "[IsDomain B]
alone fails" only considered hypotheses one-at-a-time; the joint addition is
sound — IsDomain kills the B=k×k counterexample, IsAlgClosed kills the ℚ(√2)/ℚ
counterexample). Over an algebraically closed base this also collapses the
`constants_integral_over_base_field` lemma to a one-liner and descopes the
entire (S3.*) chain.

This is endorsed by both the strategy-critic (SOUND) and progress-critic
(STUCK → pivot is the correct corrective).

## Required edits to this chapter

### 1. `thm:rigidity_over_kbar` statement block
- Add the hypothesis that the base field k̄ is ALGEBRAICALLY CLOSED
  (Lean: `[IsAlgClosed kbar]`) and of CHARACTERISTIC ZERO (`[CharZero kbar]`).
  The current statement reads "Let k̄ be a field"; change to "Let k̄ be an
  algebraically closed field of characteristic zero". The Lean `\lean{}` hint
  stays `AlgebraicGeometry.rigidity_over_kbar`. This matches the theorem's name
  and its existing docstring (which already says k̄ algebraically closed) — the
  hypothesis was simply missing from the formal statement.
- The proof-decomposition prose (C.2.b reduction, C.2.c image-dimension
  dichotomy, C.2.d cotangent-vanishing keystone, C.2.e set-to-scheme) stays,
  but any sentence asserting the statement is "k-agnostic" / "over an arbitrary
  base field" / "no algebraic-closure hypothesis" / "Galois descent dropped"
  must be REWRITTEN to the alg-closed reading. The rigidity is proved over k̄;
  descent to a general k is a SEPARATE downstream step (see edit 4 below and
  the genus-0 witness chapter).

### 2. `lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` (KDM) — the FALSE lemma, corrected
- CORRECTED statement: for k a field that is ALGEBRAICALLY CLOSED and of
  CHARACTERISTIC ZERO (`[Field k] [IsAlgClosed k] [CharZero k]`), and B a
  finite-type standard-smooth k-algebra of relative dimension n that is also an
  INTEGRAL DOMAIN (`[Algebra.FiniteType k B]`,
  `[Algebra.IsStandardSmoothOfRelativeDimension n k B]`, `[IsDomain B]`): if
  `KaehlerDifferential.D k B b = 0` then `b ∈ (algebraMap k B).range`.
- Remove the iter-151 `% NOTE` flagging it false-as-stated (the corrected
  statement is TRUE) — but ADD a brief `% NOTE` recording WHY both hypotheses
  are needed (cite the two counterexamples and which hypothesis excludes each),
  so the geometric content is not silently re-lost in a future edit.
- CORRECTED proof sketch (replace the (C.d) "transfer step" / S5.a / S5.b prose
  which described closing a FALSE goal). The mathematically correct argument:
  * B is an integral domain, smooth and finite-type over the algebraically
    closed field k of characteristic 0. Let K = Frac(B), a finitely generated
    field extension of k. Smoothness ⟹ K/k is separably generated; char 0 makes
    this automatic.
  * Because k is algebraically closed and B is a domain finite-type over k
    (a geometrically integral situation over an algebraically closed field),
    k is algebraically closed IN K: any element of K algebraic over k lies in k.
  * The universal derivation localises: `D_B b = 0` gives `d_{K/k} b = 0` in
    Ω_{K/k}. For a separable (here char-0) extension K/k, the kernel of
    `d : K → Ω_{K/k}` is exactly the relative algebraic closure of k in K — the
    "field of constants". Combined with the previous bullet (k alg-closed in K),
    `ker d_{K/k} = k`. Hence `b ∈ k`, i.e. `b ∈ (algebraMap k B).range`.
  * The previously-closed FREE-CASE helpers (`_mvPoly_*`: in char 0, a
    multivariate polynomial with all partials zero is a constant) + the
    standard-smooth presentation lift + the `KaehlerDifferential.map_D`
    functoriality remain valid and may be reused for the polynomial-ring layer
    of the argument; they are correct because the free polynomial ring is itself
    geometrically integral.
- Out of scope: do NOT attempt to write Lean tactics; give the mathematical
  argument only. Flag (in the prose, as a `% NOTE`) that the precise Mathlib
  lemma for "ker d_{K/k} = relative algebraic closure of k in K for a separable
  extension" should be confirmed by the prover (it is the residual content);
  if Mathlib lacks it directly, the prover assembles it from the
  separating-transcendence-basis freeness of Ω_{K/k}.

### 3. `lem:constants_integral_over_base_field` — collapse under [IsAlgClosed]
- The Lean signature is unchanged in its conclusion (`RingHom.range (appTop.hom) = ⊤`)
  but the proof now ASSUMES the base field is algebraically closed (the lemma is
  invoked only with k = k̄ in the alg-closed rigidity setting). State this.
- Replace the path-(b) 4×(S3.*) factorisation proof AND the path-(a) 7-step
  flat-base-change chain with the COLLAPSED proof:
  * Steps (1)–(2) unchanged: `IsReduced X` + `GeometricallyIrreducible` ⟹ X
    integral ⟹ Γ(X,O_X) is a field (`isField_of_universallyClosed`); properness
    ⟹ the `appTop` map is finite (`finite_appTop_of_universallyClosed`). So
    Γ(X,O_X) is a finite field extension of k.
  * NEW step (3): since k is algebraically closed, a finite (hence integral)
    field extension is trivial: apply
    `IsAlgClosed.algebraMap_bijective_of_isIntegral`
    (`Mathlib.FieldTheory.IsAlgClosed.Basic` — verified to exist:
    `{k K} [Field k] [Ring K] [IsDomain K] [IsAlgClosed k] [Algebra k K]
    [Algebra.IsIntegral k K] : Function.Bijective (algebraMap k K)`). Bijectivity
    ⟹ surjectivity of `algebraMap k Γ`, which gives the `range = ⊤` conclusion.
- PRUNE the `\uses{lem:S3_sep_1…, lem:S3_sep_2…, lem:S3_pi_1…, lem:S3_pi_2…}`
  from this lemma's proof block — the (S3.*) chain is no longer used. Keep the
  (S3.*) lemma LABELS defined elsewhere (do not delete labels), but mark the
  four (S3.*) lemma blocks (if their prose lives in THIS chapter) as
  "DESCOPED under the alg-closed pivot — general-over-k Mathlib-PR fodder, not
  on the M2.a critical path". (If the (S3.*) blocks live in ChartAlgebraS3.tex,
  just prune the \uses here; a separate writer handles that chapter.)

### 4. Over-k framing reconciliation
- Any paragraph asserting the iter-127 "over-k commitment" (rigidity established
  directly over arbitrary k, no base-change, Galois descent DROPPED) must be
  rewritten: rigidity is now proved over k̄; the genus-0 witness over a general
  base field k descends the constancy conclusion along Spec k̄ → Spec k. The
  descent of morphism equality is a short consequence of
  `AlgebraicGeometry.Flat.epi_of_flat_of_surjective` (faithfully-flat covers are
  epimorphisms in the category of schemes) — record this as the downstream
  disposition, with the detailed descent living in the genus-0 witness chapter.

## References
Stacks citations already in the chapter (00T7, etc.) stay. The new Mathlib
anchor `IsAlgClosed.algebraMap_bijective_of_isIntegral` is a Mathlib lemma, not
an external source — no `% SOURCE:` block needed for it.

## Out of scope
- Do NOT edit other chapters (Jacobian.tex, AbelJacobi.tex, ChartAlgebraS3.tex
  are handled by separate writers this iter). Flag cross-chapter issues in
  "Notes for Plan Agent".
- Do NOT add `\leanok` or `\mathlibok` markers (managed by sync_leanok / review).
- Do NOT write Lean tactic code.
