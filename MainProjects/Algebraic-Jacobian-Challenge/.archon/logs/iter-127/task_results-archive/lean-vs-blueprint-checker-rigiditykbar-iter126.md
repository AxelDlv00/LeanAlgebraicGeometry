# Lean ↔ Blueprint Check Report

## Slug
rigiditykbar-iter126

## Iteration
126

## Files audited
- Lean: `AlgebraicJacobian/RigidityKbar.lean` (87 LOC, NEW iter-126)
- Blueprint: `blueprint/src/chapters/RigidityKbar.tex` (~95 LOC, NEW iter-126)

## Per-declaration

### `\lean{AlgebraicGeometry.rigidity_over_kbar}` (chapter: `\thm:rigidity_over_kbar`, L16–30)

- **Lean target exists**: yes — `AlgebraicGeometry.rigidity_over_kbar` at `RigidityKbar.lean:75–87`.
- **Signature matches**: yes (full LSP-confirmed signature):
  ```
  {kbar : Type u} [Field kbar] {C : Over (Spec (CommRingCat.of kbar))}
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] (_hgenus : genus C = 0)
    {A : Over (Spec (CommRingCat.of kbar))} [GrpObj A] [IsProper A.hom]
    [Smooth A.hom] [GeometricallyIrreducible A.hom]
    (f : C ⟶ A) (p : 𝟙_ ... ⟶ C) (_hf : p ≫ f = η[A]) :
    f = (toUnit C ≫ η[A])
  ```
  Encoding is the directive's Option B: abstract smooth-proper-geometrically-
  irreducible curve of relative dimension `1` with `genus C = 0`, exactly as
  the blueprint's "Encoding note" at L29 documents. Hypothesis predicates
  (`SmoothOfRelativeDimension 1`, `IsProper`, `GeometricallyIrreducible`) and
  the target's predicates (`Smooth`, `IsProper`, `GeometricallyIrreducible`,
  `GrpObj`) are pinned both in the prose (L20–25) and in the Lean signature,
  with no Mathlib-predicate ambiguity. The conclusion `f = (toUnit C ≫ η[A])`
  is the categorical rendering of the blueprint's
  `f = (C → \Spec\bar k \xrightarrow{\eta_A} A)` (L26): `toUnit C : C ⟶ 𝟙_`
  is the structural map, `η[A] : 𝟙_ ⟶ A` the identity element morphism.
- **Proof follows sketch**: N/A — body is `sorry`. **Directive-authorized**:
  the chapter's L11–12 explicitly states the iter-126 scaffold lands the
  named declaration with a single `sorry` body gated on the iter-129+
  shared cotangent-vanishing pile (pieces (i)+(ii)+(iii)), and the
  directive at "Out of scope" says NOT to verify body closure.
- **Notes**:
  - The `(p : 𝟙_ ... ⟶ C)` hypothesis (existence of a `k̄`-rational point
    with `f(p) = η[A]`) appears in the Lean exactly as in the blueprint's
    L24–25 prose. `p` is not used in the conclusion (only via `_hf`),
    which is correct: `p` is needed to pin the constant value as `η[A]`
    rather than some other element, but the conclusion is an intrinsic
    equality of morphisms.
  - The proof decomposition C.2.b / C.2.c / C.2.d / C.2.e (L43–56 of
    the chapter) is a faithful description of what the `sorry` body
    conceptually represents. C.2.b names `Scheme.Over.ext_of_eqOnOpen`
    (the iter-125 refactored project rigidity lemma at
    `Rigidity.lean:91`, verified to exist) as the closure tactic.
  - The shared-pile inventory L63–77 is a faithful description of the
    keystone (C.2.d) gating; target names there are addressed below.

## Red flags

(No critical findings. `sorry` body is authorized per chapter L11–12
and per the directive's "Out of scope" note. No excuse-comments on
substantive declarations; no axioms; no `:= True` / `:= rfl` patterns.)

## Unreferenced declarations (informational)

None. The file contains exactly one declaration (`rigidity_over_kbar`)
plus the `set_option`/`universe`/`namespace`/`open` boilerplate. Coverage
is complete.

## Blueprint adequacy for this file

A bidirectional check: does the chapter give a prover enough detail to
formalize this file correctly?

- **Coverage**: 1/1 — the file's sole substantive declaration is
  `\lean{...}`-referenced from the chapter's Theorem block at L18.
- **Proof-sketch depth**: **adequate** for the iter-126 scaffold scope.
  - C.2.b (L44) — explicitly names the project's `Scheme.Over.ext_of_eqOnOpen`
    as the closure tactic, names the operands (`g₁ := f`, `g₂ := c`,
    `U := ℙ¹_{k̄}`), and verifies the rigidity lemma's hypotheses
    (reduced source from smooth, geometrically irreducible source,
    separated target from proper). Prover-actionable.
  - C.2.c (L46–51) — three-case dimension dichotomy with explicit
    handling of each case. The middle case ("image is a single point")
    leverages the pointed hypothesis to pin the image at `{η_A}` and
    promotes to scheme-morphism equality via C.2.e. The third case
    (positive-dimensional image) defers to the C.2.d keystone. Slight
    looseness on *why* a dim-0 closed irreducible plus the marked
    point forces `f.base = const_{η_A}` (a topological-fact prover
    would still need to fill the basic set-theoretic step), but this
    is minor.
  - C.2.d (L53) — defers to the shared cotangent-vanishing pile,
    which is documented in detail at L58–77 with per-piece naming
    idiom recommendations and LOC budgets. The deferral is
    appropriate: the keystone is the iter-129+ build target, not the
    iter-126 scaffold body.
  - C.2.e (L55) — "Standard reduced-source / separated-target
    argument, integrated into the application of C.2.b." This is the
    thinnest sub-step in the decomposition; a future prover will need
    to expand it to "the set-level pointwise equality from C.2.c plus
    `ext_of_eqOnOpen` on the *whole* curve as `U`". The wording is
    adequate but borderline; flagged as **minor** below.
- **Hint precision**: **precise**. The `\lean{AlgebraicGeometry.rigidity_over_kbar}`
  at L18 pins the declaration name exactly. The "Encoding note" at L29
  explicitly enumerates the four typeclass predicates (`SmoothOfRelativeDimension 1`,
  `IsProper`, `GeometricallyIrreducible`, `genus C = 0`) and the
  *reason* for the Option-B encoding choice (Mathlib `b80f227` lacks
  a packaged `ProjectiveSpace n S` as `Scheme.Over S`). No ambiguity
  about which Mathlib predicates to use.
- **Generality**: **matches need**. The hypothesis on `kbar` is just
  `[Field kbar]` (no `[IsAlgClosed kbar]`); the chapter at L20
  explicitly authorizes this looseness ("the statement is intrinsic
  to `\bar k` and does not require an ambient base `k`"). The
  existence of the `k̄`-rational point `p` substitutes for the
  algebraic-closure hypothesis at the type level. **Minor concern**:
  the chapter does not state whether `[IsAlgClosed kbar]` will need
  to be *added* when the body closure forces it (e.g. if the C.2.d
  keystone's Frobenius-iteration descent of piece (iii) requires
  perfectness or alg-closedness); flagged below.
- **Target-name verification for the shared-pile inventory (L63–77)**:
  - `AlgebraicGeometry.GrpObj.omega_free` and
    `AlgebraicGeometry.GrpObj.omega_rank_eq_dim` — **proposed gap-fill
    names**, do not exist in Mathlib `b80f227` (local search empty).
    The chapter is explicit that these are NEEDS_MATHLIB_GAP_FILL
    targets, citing `analogies/cotangent-vanishing-pile.md`'s
    naming-idiom decision that `GrpObj` (not `AbelianVariety`, which
    has no Mathlib namespace) is the canonical home. Not hallucinated.
  - `AlgebraicGeometry.Scheme.Over.ext_of_diff_zero` — **proposed
    gap-fill name** following the iter-125 `ext_of_eqOnOpen` idiom.
    Local search empty (expected); the chapter labels it as
    NEEDS_MATHLIB_GAP_FILL. Not hallucinated.
  - `frobenius` / `iterateFrobenius` — **existing Mathlib names**,
    confirmed at `Mathlib/Algebra/CharP/Frobenius.lean` and
    `Mathlib/Algebra/CharP/Lemmas.lean` (10 local-search hits for
    `iterateFrobenius`, 5+ for `frobenius`). Not hallucinated.
  - `Scheme.Over.ext_of_eqOnOpen` (referenced from C.2.b at L44) —
    exists in-project at `AlgebraicJacobian/Rigidity.lean:91–122`.
    Not hallucinated.
- **Recommended chapter-side actions**: none must-fix; minor
  improvements catalogued below.

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  - C.2.e sub-step at L55 is one sentence and waves at "integrated
    into the application of C.2.b". A future prover would benefit
    from one extra sentence spelling out the promotion: "Apply
    `Scheme.Over.ext_of_eqOnOpen` with `U := ⊤` (the whole curve),
    where the equality of `(U.ι ≫ f.left) = (U.ι ≫ c.left)` on `U`
    follows from C.2.c's set-level pointwise equality plus reducedness
    of the source." This is editorial and does not block iter-126.
  - The chapter does not preview whether `[IsAlgClosed kbar]` will
    need to be added when piece (iii) lands. The L20 prose says the
    statement is "intrinsic to `\bar k` and does not require an
    ambient base `k`", which is correct for the *statement* but
    silent on what the *body closure* will require. A one-line note
    in the Encoding-note paragraph at L29 — "if Frobenius-iteration
    descent forces it, `[IsAlgClosed kbar]` may be added at iter-129+
    without changing the statement's intrinsic content" — would help
    the future prover.
  - Hypothesis names `_hgenus` and `_hf` are prefixed with underscores
    (Lean's intentionally-unused convention) because the body is
    `sorry`. When the body lands iter-129+, the prover will need to
    drop the underscores. The current naming is correct for the
    scaffold; this is just a heads-up note for downstream work.

Overall verdict: **The Lean file is a faithful Option-B scaffolding
of the blueprint's Theorem `\thm:rigidity_over_kbar`; the chapter
adequately previews the iter-129+ body closure via the documented
C.2.b–C.2.e decomposition and the shared-pile (i)+(ii)+(iii)
inventory, with no hallucinated target names and no critical
adequacy gaps. Three minor editorial improvements catalogued; none
blocking.**
