# Lean ↔ Blueprint Check Report

## Slug
iter181-ratcurveiso

## Iteration
181

## Files audited
- Lean: `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- Analogist (reference, not audited as source): `analogies/ratcurveiso-pin3.md`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.morphismToP1OfGlobalSections}` (chapter: `lem:morphism_to_p1_from_global_sections`)
- **Lean target exists**: yes (L218-257).
- **Signature matches**: partial.
  - Blueprint states the lemma for an *arbitrary* invertible sheaf
    `ℒ` with sections `s₀, s₁ ∈ H⁰(X, ℒ)` of empty common zero locus
    (L96-116).
  - Lean takes a graded `k̄`-algebra hom
    `f : MvPolynomial (Fin 2) kbar →+* Γ(X.left, ⊤)` directly into the
    global ring `Γ(X, ⊤)`, i.e. the *trivialised* form. This is the
    `ℒ = O_X` (or post-chart-trivialisation) specialisation, not the
    general invertible-sheaf statement.
  - The blueprint proof body (L142-154) does acknowledge that the
    project-bespoke wrapper performs chart-glue via
    `Scheme.Cover.glueMorphisms`. The L218 Lean signature is the
    inner trivialised wrapper around `Proj.fromOfGlobalSections`; the
    chart-glue layer that bridges to the general-`ℒ` statement is not
    in this file (or not yet exposed under a separate name).
  - The Lean signature additionally takes a `_halg` `kbar`-algebra
    compatibility witness that the blueprint does not surface in the
    informal statement — this is essentially the implicit "morphism is
    over `Spec k̄`" condition that the blueprint's "morphism of
    `\bar k`-schemes" formulation packages silently.
- **Proof follows sketch**: yes — the Lean body is the
  `Proj.fromOfGlobalSections` + `Over.homMk` packaging the blueprint
  describes (L122-154); the `_halg` rewrite chain in L239-257 is the
  `IsScalarTower` + `Scheme.toSpecΓ_naturality` chase the blueprint
  prose glosses over.
- **Notes**: body is **closed (no `sorry`)**. The naming `_halg`/`_hf`
  prefix suggests these hypotheses are unused in the body, but they
  *are* both consumed in the `change`/`rw` chain. Mild prose-vs-Lean
  generality gap (general-`ℒ` blueprint statement vs trivialised Lean
  signature) is fully documented in the Lean docstring (L195-202).

### `\lean{AlgebraicGeometry.Scheme.morphism_degree_via_pole_divisor}` (chapter: `lem:degree_via_pole_divisor`)
- **Lean target exists**: yes (L310-320).
- **Signature matches**: **no — strictly weaker than the blueprint
  statement**.
  - Blueprint asserts:
    * `φ` is finite,
    * `k̄(ℙ¹) ↪ K(C)` is finite of degree `d = deg(φ) ≥ 1`,
    * **For every closed point `Q ∈ ℙ¹`,
       `deg(φ^*[Q]) = deg(φ)`**,
    * specialising to `Q = ∞`,
       `deg(φ) = deg(Σ ord_P(φ^* t_∞)·[P])`.
  - Lean output is just
    `∃ (d : ℕ) (D : C.left.WeilDivisor), 0 < d ∧ D.degree = d`. The
    type asserts existence of *some* positive-degree Weil divisor on
    `C` — it does NOT mention `φ` in the output at all, does NOT
    identify `D` with the pole divisor `φ^*[∞]`, and does NOT pin
    `d = [K(C) : k̄(ℙ¹)]`. A witness `(d := 1, D := [P])` for any
    closed point `P ∈ C` (which exists on a non-empty smooth proper
    curve) would discharge the type without saying anything about
    `φ`.
- **Proof follows sketch**: N/A — body is `:= sorry` (L320).
- **Notes**: the Lean docstring (L296-306) and the chapter status block
  (L37-50) **both acknowledge** this as a deliberate file-skeleton
  weakening pending iter-182+ body work. Per the project rules, this
  is a **signature mismatch with the blueprint's prose** — the chapter
  asks for a concrete pole-divisor identity, the Lean type asks only
  for "some positive divisor exists". Before any iter-182+ body work
  begins, the type must be strengthened (e.g. to take a closed point
  `Q : 𝟙_ ⟶ ProjectiveLineBar kbar` and assert that the existential
  divisor is the pullback `φ^*[Q]` of a specified `Q`, or directly
  `Scheme.WeilDivisor.degree (φ^*[∞]) = [K(C) : k̄(ℙ¹)]`). The
  current type cannot host the iter-182+ body's substantive content.

### `\lean{AlgebraicGeometry.Scheme.iso_of_degree_one}` (chapter: `lem:degree_one_morphism_iso`)
- **Lean target exists**: yes (L400-414).
- **Signature matches**: **partial / divergent (iter-181 intentional
  refinement)**.
  - Blueprint states (L271-275): "let `φ : C → C'` be a non-constant
    morphism with `deg(φ) = 1`. Then `φ` is an isomorphism".
    Blueprint proof body (L281-298) elaborates: degree-1 hypothesis
    via `lem:degree_via_pole_divisor` gives function-field extension
    `[k̄(C) : k̄(C')] = deg(φ) = 1`, so `φ^#` is a function-field
    iso, then Hartshorne I.6.12 lifts.
  - Lean (iter-181 mutation) replaces the `deg(φ) = 1` hypothesis
    with:
    * `[Algebra C'.left.functionField C.left.functionField]` (a
      typeclass binder), plus
    * `Module.finrank C'.left.functionField C.left.functionField = 1`.
  - The two are *equivalent in the intended call-site instance* (the
    canonical `φ`-induced function-field map), but the blueprint
    chapter prose does NOT document:
    1. The replacement of `deg(φ) = 1` by an explicit `finrank = 1`
       equation (this is reasonable and follows the chapter's own
       `[k̄(C):k̄(C')] = 1` reformulation — but the chapter's
       `\lean{...}`-tagged statement block still uses `deg(φ) = 1`).
    2. The new `[Algebra K(C') K(C)]` typeclass binder. The intended
       instance at every call site is the canonical
       `φ`-induced function-field map (composite of `Scheme.Hom.stalkMap`
       at the generic point with the `IsFractionRing` extension), but
       this canonical instance is described **only** in the Lean
       docstring (L362-365) and in `analogies/ratcurveiso-pin3.md`
       (Decision 2). The chapter does not surface it.
- **Proof follows sketch**: N/A — body is `:= sorry` (L414).
- **Notes**: this is the iter-181 Lane I mutation per
  `analogies/ratcurveiso-pin3.md` Decision 2 (`DIVERGE_INTENTIONALLY`).
  The Lean refinement is well-justified (the analogist showed the old
  `Nonempty (K(C') ≃+* K(C))` placeholder is *strictly weaker* than
  the iter-182+ body needs: the birational-extension argument
  requires the iso to be induced by `φ`, not an abstract ring iso).
  The chapter-side prose update is acknowledged in the prover
  task_result as "blueprint-writer iter-182 plan-phase". **Status:
  blueprint-writer follow-up explicitly pending; flagged below.**

## Pin 4 (cross-reference only — declared in AVR.lean)

### `\lean{AlgebraicGeometry.genusZero_curve_iso_P1}` (chapter: `thm:genus_zero_curve_iso_p1`)
- Lives in `AlgebraicJacobian/AbelianVarietyRigidity.lean:290`, not
  in the file under audit. Cross-reference at this file's L137-161
  matches the AVR-side declaration verbatim and is correct.

## Red flags

### Placeholder / weakened-wrong signature
- `Scheme.morphism_degree_via_pole_divisor` at L310-320: body is
  `sorry` AND the type is significantly weaker than the blueprint
  statement (omits the `deg(φ) = deg(φ^*[Q])` core identity; output
  doesn't even mention `φ`). **Documented file-skeleton weakening,
  but downstream consumers of this lemma cannot extract the
  pole-divisor identity from this signature.** Must be strengthened
  before iter-182+ body work lands.

### Signature ↔ blueprint divergence (acknowledged but un-mirrored)
- `Scheme.iso_of_degree_one` at L400-414: iter-181 signature
  refinement is intentional and well-grounded, but the chapter
  prose was not updated in the same iter. The blueprint
  `\lean{...}`-tagged statement block still pins `deg(φ) = 1`
  hypothesis, while the Lean signature pins
  `Module.finrank K(C') K(C) = 1` + `[Algebra K(C') K(C)]`. A
  prover reading the chapter cold today would not arrive at the
  iter-181 Lean signature.

### No `sorry`-in-substantive-body discoveries beyond the documented sorries
- No excuse-comments, no `:= True`, no `Classical.choice ⟨…⟩` patterns.
- No `axiom` declarations.

## Unreferenced declarations (informational)

None — this file contains exactly the three pinned declarations
(`morphismToP1OfGlobalSections`, `morphism_degree_via_pole_divisor`,
`iso_of_degree_one`), each `\lean{...}`-referenced. Coverage 3/3.

## Blueprint adequacy for this file

- **Coverage**: 3/3 substantive Lean declarations have `\lean{...}`
  blocks. 0 unreferenced helpers.
- **Proof-sketch depth**: adequate for Pin 1 (chart-glue + Mathlib
  API + uniqueness all named); adequate for Pin 2 (finite-morphism
  reduction + Hartshorne II.6.9 multiplicativity); adequate for
  Pin 3 (both the equivalence-of-categories framing and the
  spelled-out direct-sheaf-cohomology alternative are given).
- **Hint precision**: precise for Pin 1; precise for Pin 2 (chapter
  pins the correct, stronger statement than Lean currently has);
  **loose** for Pin 3 — the chapter prose-side hypothesis
  (`deg(φ) = 1`) does not match the iter-181 Lean signature
  (`[Algebra K(C') K(C)]` + `Module.finrank = 1`), and the
  canonical-`Algebra`-instance convention is not documented in the
  chapter.
- **Generality**: matches need for Pins 2, 3. Pin 1 has a
  generality split — the blueprint statement is the general
  invertible-sheaf form, the Lean signature is the trivialised form;
  the chart-glue layer that bridges them is acknowledged in the
  blueprint proof body but is not formalised as a separate named
  Lean declaration in this file.
- **Recommended chapter-side actions** (for the blueprint-writing
  subagent in iter-182+):
  1. **Pin 3 statement update (highest priority)**: update the
     `lem:degree_one_morphism_iso` lemma block to match the iter-181
     Lean signature. Replace the `deg(φ) = 1` hypothesis with the
     `Module.finrank K(C') K(C) = 1` equation, and add a sentence
     noting that the `[Algebra K(C') K(C)]` instance at each call
     site is the canonical `φ`-induced function-field map (composite
     of `Scheme.Hom.stalkMap` at the generic point with
     `IsFractionRing.lift`).
  2. **Pin 3 `% NOTE:` pointer**: add a `% NOTE:` referencing
     `analogies/ratcurveiso-pin3.md` (Decision 2) so future readers
     understand the signature refinement provenance.
  3. **Pin 2 status note**: either add a `% NOTE:` documenting that
     the current Lean signature is a file-skeleton weakening
     (`∃ d D, 0 < d ∧ D.degree = d`) pending iter-182+ strengthening,
     OR (preferred) strengthen the Lean signature this iter so the
     chapter and the Lean stay in lockstep before any body work.
  4. **Pin 1 generality note (low priority)**: optionally add a
     `% NOTE:` to `lem:morphism_to_p1_from_global_sections`
     clarifying that the Lean signature is the trivialised
     specialisation and the chart-glue layer is performed inline at
     consumer call-sites.

## Severity summary

- **must-fix-this-iter**:
  * `morphism_degree_via_pole_divisor` (L310-320) **signature is
    structurally weaker than the blueprint claim** — the type is
    discharged by *any* positive-degree divisor on `C` and does not
    reference `φ`. Per the rules ("Weakened-wrong definitions: Lean
    defines a structurally-different stand-in"). The body is `sorry`
    so no false proof is shipped, but the **type must be strengthened
    before any iter-182+ prover work begins on this lemma**, else any
    body will close a vacuous statement.

- **major**:
  * `iso_of_degree_one` (L400-414) blueprint chapter prose lags the
    iter-181 Lean signature refinement; the prover task_result
    explicitly defers the chapter-side update to iter-182
    plan-phase. Not a Lean-side bug (the refinement is justified by
    the analogist), but a documented blueprint-writer follow-up.
  * `iso_of_degree_one` chapter does not document the canonical
    `[Algebra K(C') K(C)]` instance convention — call-sites need to
    know which instance is intended.

- **minor**:
  * `morphismToP1OfGlobalSections`: Lean signature is the
    trivialised specialisation of the blueprint's general
    invertible-sheaf statement; gap is acknowledged in the Lean
    docstring but a brief `% NOTE:` in the chapter would help
    readers.

## Overall verdict

Lean ↔ blueprint alignment for `RationalCurveIso.lean` ✕ `RiemannRoch_RationalCurveIso.tex`
is **acceptable for the iter-181 Lane I scope but carries one
must-fix structural signature weakening (Pin 2) and one
acknowledged blueprint-writer follow-up (Pin 3 chapter prose) that
should be sequenced into iter-182**; Pin 1 is closed and substantively
sound.
