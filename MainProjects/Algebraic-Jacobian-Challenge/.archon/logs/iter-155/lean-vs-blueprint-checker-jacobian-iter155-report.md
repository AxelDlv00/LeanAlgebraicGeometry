# Lean ↔ Blueprint Check Report

## Slug
jacobian-iter155

## Iteration
155

## Files audited
- Lean: `AlgebraicJacobian/Jacobian.lean`
- Blueprint: `blueprint/src/chapters/Jacobian.tex`

## Build status
`lean_diagnostic_messages` on the file: **no errors**. Exactly two `sorry`
warnings — line 209 (`genusZeroWitness`, the residual `key`) and line 274
(`positiveGenusWitness`, the off-limits sorry per directive). One style
long-line warning at line 330 (informational). Every other declaration,
including the entire `genusZeroWitness` skeleton apart from `key`, compiles.

## Per-declaration

### `\lean{AlgebraicGeometry.IsAlbanese}` (def:IsAlbanese)
- **Lean target exists**: yes (line 71)
- **Signature matches**: yes — four AV conditions on `J` as typeclass binders
  (`GrpObj`/`IsProper`/`Smooth`/`GeometricallyIrreducible`), body
  `∃ α, P ≫ α = η[J] ∧ ∀ {A} …, ∃! g, f = α ≫ g`. Matches the prose and the
  `rem:IsAlbanese_typeclasses` encoding note exactly.
- **Proof follows sketch**: N/A (definition)
- **notes**: Remark's "typeclass-parameter, not conjunct" claim is accurate.

### `\lean{AlgebraicGeometry.IsAlbanese.ofCurve}` (def:IsAlbanese_ofCurve)
- **Lean target exists**: yes (line 81) — `Classical.choose h`.
- **Signature matches**: yes.
- **Proof follows sketch**: yes (Classical.choose on the existential body).

### `\lean{AlgebraicGeometry.IsAlbanese.comp_ofCurve}` (lem:IsAlbanese_comp_ofCurve)
- **Lean target exists**: yes (line 86)
- **Signature matches**: yes — `P ≫ h.ofCurve = η[J]`.
- **Proof follows sketch**: yes (`.1` of `Classical.choose_spec`).

### `\lean{AlgebraicGeometry.IsAlbanese.exists_unique_ofCurve_comp}` (lem:IsAlbanese_exists_unique_ofCurve_comp)
- **Lean target exists**: yes (line 92)
- **Signature matches**: yes.
- **Proof follows sketch**: yes (`.2` of `Classical.choose_spec`).

### `\lean{AlgebraicGeometry.IsAlbanese.unique}` (thm:IsAlbanese_unique)
- **Lean target exists**: yes (line 102)
- **Signature matches**: yes — `∃! (e : J₁ ⟶ J₂), h₂.ofCurve = h₁.ofCurve ≫ e`.
- **Proof follows sketch**: yes — standard universal-property argument; computes
  `g ≫ h = 𝟙` and `h ≫ g = 𝟙` internally but returns only the morphism +
  uniqueness, exactly as `rem:IsAlbanese_unique_iso` describes.

### `\lean{AlgebraicGeometry.JacobianWitness}` (def:JacobianWitness)
- **Lean target exists**: yes (line 157)
- **Signature matches**: yes — all seven fields (`J`, `grpObj`, `proper`,
  `smooth`, `geomIrred`, `smoothGenus`, `isAlbaneseFor`) present and typed as
  the definition prose lists them; `isAlbaneseFor : ∀ P, IsAlbanese C P J`
  reverses the quantifier order exactly as `rem:JacobianWitness_quantifier_order`
  states.
- **Proof follows sketch**: N/A (structure)

### `\lean{AlgebraicGeometry.genusZeroWitness}` (def:genusZeroWitness) — DIRECTIVE FOCUS
- **Lean target exists**: yes (line 209)
- **Signature matches**: yes — `(h : genus C = 0) → JacobianWitness C`.
- **Proof follows sketch**: **yes (faithful), one honest residual sorry**.
  Field-by-field against the chapter proof:
  - `J := 𝟙_ (Over (Spec k))` — terminal object = C.3 "Take J := 𝟙" /
    proof "Underlying scheme". ✓
  - `grpObj/proper/smooth/geomIrred` — the four trivial structural instances on
    the identity; matches the C.3 "Group-object structure, properness,
    smoothness, geometric irreducibility" paragraph. ✓
  - `geomIrred := geometricallyIrreducible_id_Spec k` — the chapter names this
    exact project helper. ✓
  - `smoothGenus := by rw [h]; exact … 0 …` — matches the
    "Smoothness of relative dimension genus C" paragraph (rewrite by `h`,
    reduce to `SmoothOfRelativeDimension 0 (id)`). ✓
  - `isAlbaneseFor`: `α := toUnit C` (✓ proof "universal pointed morphism is
    toUnit C"); pointed condition `toUnit_unique _ _` (✓ "both sides are
    morphisms 𝟙_→𝟙_, unique endomorphism"); existence factor `g := η[A]`
    (✓ "take g := η_A").
  - **Residual sorry** `key : f = toUnit C ≫ η[A]` (line 240): `lean_goal`
    confirms the goal is exactly `f = toUnit C ≫ η`, with `_hf : P ≫ f = η`
    and `h : genus C = 0` in scope. This is **precisely** the C.2 rigidity
    equation (`f` = constant morphism at `η_A`); `toUnit C ≫ η[A]` is the
    constant morphism `c` of C.2.b. The gap is **exactly** the C.2/C.2.f content
    (rigidity over `k̄` via `rigidity_over_kbar` + faithfully-flat descent to
    `k`). Not laundered, not broadened: it is an arbitrary AV target `A` and an
    arbitrary pointed `f` under `genus C = 0`, which cannot be discharged
    trivially.
  - **Uniqueness clause**: closes (no sorry) via `Over.toUnit_left` +
    `Flat.epi_of_flat_of_surjective` + `Over.epi_of_epi_left` + `cancel_epi`.
    See "Blueprint adequacy" — this is a *different and more correct* argument
    than the chapter's prose, matching the directive's "uniqueness-via-epi".

### `\lean{AlgebraicGeometry.positiveGenusWitness}` (def:positiveGenusWitness)
- **Lean target exists**: yes (line 274) — bare `sorry` (off-limits per
  directive; existence not re-flagged).
- **Signature matches**: yes — `(hg : 0 < genus C) → JacobianWitness C`.
- **Proof follows sketch**: N/A — Route-A M3 gap, accurately described by the
  chapter and the Lean docstring (Picard scheme / FGA). Comments correct.

### `\lean{AlgebraicGeometry.nonempty_jacobianWitness}` (thm:nonempty_jacobianWitness)
- **Lean target exists**: yes (line 304)
- **Signature matches**: yes — `Nonempty (JacobianWitness C)`.
- **Proof follows sketch**: yes — `by_cases h : genus C = 0` delegating to
  `genusZeroWitness`/`positiveGenusWitness`, exactly the iter-135 body
  restructure the chapter documents.

### `\lean{AlgebraicGeometry.Jacobian}` (def:Jacobian)
- **Lean target exists**: yes (line 330) — `(jacobianWitness C).J`.
- **Signature matches**: yes.
- **Proof follows sketch**: N/A (definition by projection, as the chapter says).

### `\lean{AlgebraicGeometry.Jacobian.instGrpObj}` (thm:Jacobian_grpObj)
- **Lean target exists**: yes (line 340) — projects `.grpObj`. ✓

### `\lean{AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus}` (thm:Jacobian_smooth_genus)
- **Lean target exists**: yes (line 344) — projects `.smoothGenus`. ✓

### `\lean{AlgebraicGeometry.Jacobian.instIsProper}` (thm:Jacobian_proper)
- **Lean target exists**: yes (line 348) — projects `.proper`. ✓

### `\lean{AlgebraicGeometry.Jacobian.instGeometricallyIrreducible}` (thm:Jacobian_geomIrred)
- **Lean target exists**: yes (line 351) — projects `.geomIrred`. ✓

## Red flags

### Placeholder / suspect bodies
None beyond the two authorized sorries. The `genusZeroWitness` residual sorry is
narrow (one rigidity equation), correctly localized, and matches the C.2.f gap
the chapter names — not a bare/laundered placeholder.

### Excuse-comments
None. The `genusZeroWitness` docstring/comments label the residual gap as a
NAMED GAP (`rigidity_over_kbar` + descent) and are accurate (see Blueprint
adequacy item 2 — they are in fact *more* accurate than the chapter).

### Axioms / Classical.choice on non-trivial claims
`jacobianWitness` (line 314) uses `Classical.choice (nonempty_jacobianWitness C)`
— authorized: it extracts a witness whose existence is the chapter's named
foundational hypothesis (thm:nonempty_jacobianWitness). `IsAlbanese.ofCurve`
uses `Classical.choose`, which the chapter explicitly prescribes
(def:IsAlbanese_ofCurve). No unauthorized axioms.

## Unreferenced declarations (informational)
- `geometricallyIrreducible_id_Spec` (line 134) — helper. NOT `\lean{...}`-tagged,
  but the chapter prose (proof of def:genusZeroWitness) cites it by full name as
  the geometric-irreducibility instance. Acceptable as a helper; the prose
  reference is sufficient.
- `jacobianWitness` (line 314) — `Classical.choice` extractor helper for
  `Jacobian`; the chapter prose (proof of thm:Jacobian_grpObj) references it by
  name. Acceptable.

## Blueprint adequacy for this file
- **Coverage**: 14/14 substantive declarations have a `\lean{...}` block. Two
  helpers (`geometricallyIrreducible_id_Spec`, `jacobianWitness`) are
  prose-referenced but untagged — acceptable.
- **Proof-sketch depth**: adequate overall, with **one divergence** (item 1):
  the chapter's `genusZeroWitness` *uniqueness* sketch describes a different
  argument than the Lean uses.
- **Hint precision**: precise for all `\lean{...}` targets. One **accuracy
  issue** on a cross-referenced declaration's hypotheses (item 2).
- **Generality**: matches need.

**Item 1 (minor) — uniqueness argument divergence.** The chapter's
def:genusZeroWitness proof ("Uniqueness") justifies uniqueness of `g` via "the
universal property of the terminal object 𝟙 … a morphism out of 𝟙 … is
determined by where it sends the unique generator." This is mathematically loose
(morphisms *out of* a terminal object are global points and are **not** unique
in general; the terminal property gives uniqueness of morphisms *into* 𝟙). The
Lean instead uses the sound **epi-cancellation** argument (cancel `toUnit C`,
whose underlying `C.hom` is faithfully flat + surjective hence epi) — which is
exactly the "uniqueness-via-epi" step the directive's known-issues references.
The Lean is correct and complete; the *chapter prose* describes a weaker/dubious
argument. Recommend rewriting the chapter's uniqueness paragraph to the
epi-cancellation argument actually formalized.

**Item 2 (minor) — char-p / `CharZero` description of `rigidity_over_kbar`.**
The chapter (C.2.g, infrastructure-summary (γ), and Layer I) states that
`rigidity_over_kbar` "now carries `[IsAlgClosed kbar]`" with characteristic-`p`
handled via piece (iii) (absolute Frobenius `F_X`). The actual declaration
(`RigidityKbar.lean:75-76`) carries **`[IsAlgClosed kbar] [CharZero kbar]`** —
i.e. char-`p` is *excluded by hypothesis*, not Frobenius-handled. The Lean
comment inside `genusZeroWitness` (lines 206-207, 236-238) correctly flags this
("`rigidity_over_kbar` additionally requires `[CharZero kbar]`, so the char-`p`
arm … is also unbacked"). So the **chapter prose is the over-optimistic side**
and contradicts both the real signature and this file's own comment. This does
not affect the honesty of the residual sorry (it is a sorry regardless), but the
chapter overstates the generality of the cited lemma. Recommend the chapter note
the current `[CharZero kbar]` restriction (piece (iii)/Frobenius char-`p`
handling is aspirational, not yet in the signature).

**Item 3 (trivial) — stale line citation.** The chapter's def:genusZeroWitness
proof cites `geometricallyIrreducible_id_Spec` at
"`AlgebraicJacobian/Jacobian.lean:120`--`126`"; the declaration is actually at
lines 134-140. Cosmetic.

- **Recommended chapter-side actions** (for a blueprint-writing subagent, all
  non-blocking):
  1. Replace the def:genusZeroWitness uniqueness prose with the epi-cancellation
     argument (cancel the faithfully-flat-surjective epi `toUnit C`).
  2. Correct the `rigidity_over_kbar` hypothesis description: it currently
     carries `[IsAlgClosed kbar] [CharZero kbar]`; char-`p`/Frobenius handling
     is not yet in the signature.
  3. Update the `geometricallyIrreducible_id_Spec` line citation to 134-140.

## Severity summary
- **must-fix-this-iter**: none.
- **major**: none.
- **minor**: (1) uniqueness-argument prose divergence (Lean correct, chapter
  loose); (2) chapter overstates `rigidity_over_kbar` char-`p` handling vs the
  real `[CharZero kbar]` signature; (3) stale line citation.

Overall verdict: The `genusZeroWitness` skeleton **faithfully realizes** the
blueprint's C.3 terminal-object construction and closes 6/7 fields plus the
uniqueness clause via real lemmas; the single residual sorry is **exactly** the
C.2/C.2.f rigidity-and-descent gap the chapter names (not laundered or
broadened), with three minor chapter-prose accuracy items and no blocking
findings.
