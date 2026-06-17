# Lean ↔ Blueprint Check Report

## Slug
thm32-iter179

## Iteration
179

## Files audited
- Lean: `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`
- Blueprint: `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}` (chapter: `thm:rational_map_to_av_extends`)
- **Lean target exists**: yes — `AlgebraicGeometry.Scheme.RationalMap.extend_to_av` at line 239.
- **Signature matches**: yes.
  - Blueprint statement (§ Setup, Theorem `thm:rational_map_to_av_extends`):
    "Let $X$ be a nonsingular variety over $\bar k$, $A$ an abelian variety
    over $\bar k$, and $f \colon X \dashrightarrow A$. Then there is a unique
    regular morphism $\widetilde f \colon X \to A$ whose restriction to a
    dense open of definition agrees with $f$."
  - Lean conclusion: `∃! (g : X.left ⟶ A.left), g.toRationalMap = f`.
  - The instance bundle on `X` (smooth, geometrically irreducible,
    separated, locally of finite type, integral, reduced) matches the
    "nonsingular variety over $\bar k$" convention in the module docstring,
    which itself matches the blueprint's "nonsingular variety" definition
    (§ Setup, "geometrically integral, geometrically reduced, separated
    scheme of finite type over $\bar k$ that is moreover smooth").
  - The instance bundle on `A` (`[GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom]`) matches the "abelian variety"
    convention used elsewhere in the project (cf.
    `AbelianVarietyRigidity.lean`, `Jacobian.lean`).
  - Both `kbar` universe and `IsAlgClosed` match the blueprint's "algebraically
    closed field $\bar k$".
- **Proof follows sketch**: partial.
  - Blueprint proof sketch (§ Setup, proof of `thm:rational_map_to_av_extends`):
    "Combine Theorem 3.1 with Lemma 3.3. Concretely: let $U \subseteq X$ be
    maximal of definition, $Z = X \setminus U$. (1) by `thm:codim_one_extension`,
    $\mathrm{codim}_X(Z) \geq 2$. (2) by `lem:milne_codim1_indeterminacy`,
    $Z$ is empty or pure codim 1. (3) both force $Z = \emptyset$, hence
    $f$ admits a regular representative on all of $X$. Uniqueness via
    reduced-and-separated agreement."
  - Lean body structure: derive `IsSeparated A.hom` / `LocallyOfFiniteType
    A.hom` by `inferInstance`; extract `⟨IsIntegral A.left, CodimOneFree f⟩`
    from the private helper `av_isIntegral_and_codimOneFree`; derive
    `IsReduced A.left` by `inferInstance`; apply
    `extend_of_codimOneFree_of_smooth f hcod` (project-side Milne 3.1
    specialised to a `CodimOneFree`-input form).
  - **Mathematical match**: the combination Lemma 3.3 + codim-≥2 half of
    Theorem 3.1 → `Z = ∅` is consolidated into the private helper
    `av_isIntegral_and_codimOneFree` (whose docstring at L176–179 spells out
    the exact two-step argument the blueprint enumerates). The remaining
    invocation of `extend_of_codimOneFree_of_smooth` is then literally
    "Theorem 3.1, given that the codim-1 indeterminacy obstruction is
    discharged". The Lean body's overall mathematical content thus matches
    the blueprint sketch step-for-step.
  - **Why partial**: the helper `av_isIntegral_and_codimOneFree` is
    `sorry`-bodied (directive § Known issues item 1). The proof body of
    `extend_to_av` is therefore complete in *structure* (no inline `sorry`)
    but the substantive Lemma-3.3-plus-codim-≥2 combination it consumes is
    not yet discharged. This is acknowledged in the directive's "Known
    issues" block and in the helper docstring at L181–186.
- **notes**:
  - The blueprint sketch is written as "Theorem 3.1 gives codim ≥ 2" and
    "Lemma 3.3 gives empty-or-pure-codim-1". The Lean's
    `extend_of_codimOneFree_of_smooth` is Theorem 3.1 *specialised to a
    `CodimOneFree` input* — i.e. the project has split Theorem 3.1 into
    "produces codim ≥ 2 at the indeterminacy locus" + "given codim-1
    indeterminacy-free, extends". Item (1) of the blueprint sketch is the
    half of Theorem 3.1 the helper consolidates; item (3) is the wrap-up;
    the literal Lean call `extend_of_codimOneFree_of_smooth f hcod` is the
    *second* half of Theorem 3.1 turned into the actual existence statement.
    This split is documented in `Albanese/CodimOneExtension.lean`'s header
    and in the helper's docstring; no signature departure.
  - Uniqueness (`∃!` rather than `∃`) is handled inside
    `extend_of_codimOneFree_of_smooth`, which itself returns `∃!`.
    Consistent with the blueprint's "uniqueness via reduced-and-separated
    agreement principle" remark.

## Red flags

### Placeholder / suspect bodies
- `av_isIntegral_and_codimOneFree` (L187–198) — private helper, body
  `:= sorry`. The helper packages exactly the two known pieces the
  directive identifies: (i) `IsIntegral A.left` (Mathlib `Smooth ⟹
  IsReduced` bridge gap), and (ii) `CodimOneFree f` (Lemma 3.3 + codim-≥2
  half of Theorem 3.1 not unbundled from `extend_of_codimOneFree_of_smooth`).
  Acknowledged in the directive § Known issues — **not re-flagged as
  must-fix-this-iter**; documented status flag only.

### Excuse-comments
- None. The module docstring's "iter-175 Lane J file-skeleton" / "iter-179
  Lane E body" status notes describe progress without excusing wrong
  content. The helper's docstring documents the residual `sorry` honestly
  with the exact two missing inputs.

### Axioms / Classical.choice on non-trivial claims
- None.

## Unreferenced declarations (informational)

- `av_isIntegral_and_codimOneFree` (L187, `private theorem`). Not
  blueprint-pinned. Acceptable as a helper *if* the iter-179 Lane E plan is
  to keep its `sorry` localised here. **Comment for downstream**: once the
  two missing inputs land (Mathlib `Smooth ⟹ IsReduced` bridge + a
  standalone `codim ≥ 2 at indeterminacy of map to a complete variety`
  lemma exported from `Albanese/CodimOneExtension.lean`), this helper
  should close axiom-clean by inlining the two derivations; at that point
  it can either remain `private` (current behaviour) or be promoted to a
  blueprint-pinned lemma alongside `extend_to_av`.

## Blueprint adequacy for this file

- **Coverage**: 1/1 blueprint-pinned Lean declaration accounted for. 1
  helper (`av_isIntegral_and_codimOneFree`) is unpinned and acceptable as
  helper-only (a `sorry`-consolidator that will be inlined once its two
  sub-pieces land upstream).
- **Proof-sketch depth**: adequate. The three-step enumerate in the
  blueprint (L86–97) pins the exact two inputs (`thm:codim_one_extension`
  + `lem:milne_codim1_indeterminacy`) and the exact combination ("$Z$ has
  codim $\geq 2$ and is empty-or-pure-codim-1, hence $Z = \emptyset$").
  The Lean body's structure matches.
- **Hint precision**: precise. `\lean{AlgebraicGeometry.Scheme.RationalMap.extend_to_av}`
  pins the exact target; namespace housing
  (`AlgebraicGeometry.Scheme.RationalMap`) matches the Mathlib idiom the
  blueprint § Lean encoding (L182–206) recommends.
- **Generality**: matches need. The blueprint's nonsingular-variety and
  abelian-variety conventions (§ Setup) match the Lean's instance bundles
  one-for-one.
- **Minor adequacy gap (informational, not blocking)**: The blueprint
  proof sketch does not mention that on the Lean side the abelian-variety
  convention does NOT carry `IsIntegral A.left` / `IsSeparated A.hom` /
  `LocallyOfFiniteType A.hom` / `IsReduced A.left` automatically — the
  prover had to materialise these to feed
  `extend_of_codimOneFree_of_smooth`. The Lean ended up writing a 5-line
  instance-resolution preamble (L251–255) plus a `sorry`-bodied helper
  carrying `IsIntegral A.left` because the `Smooth ⟹ IsReduced` Mathlib
  bridge is missing at the pinned commit. The blueprint's § Lean encoding
  (L182–206) currently says "the proof body imports … in the three-step
  pattern above"; a one-line addition flagging the instance-resolution
  preamble (and the `IsIntegral A.left` Mathlib gap as a transient
  obstacle) would make the chapter exactly match what a prover faces in
  practice.
- **Recommended chapter-side actions**:
  - (Minor, optional) Append a one-line note to § Lean encoding (around
    L207–211) of the form: "On the Lean side, the abelian-variety
    convention `[GrpObj A] [IsProper A.hom] [Smooth A.hom]
    [GeometricallyIrreducible A.hom]` does not directly synthesise
    `IsIntegral A.left` / `IsReduced A.left` / `IsSeparated A.hom` /
    `LocallyOfFiniteType A.hom`; the proof body materialises these by
    `inferInstance` (with the `IsIntegral A.left` step transiently routed
    through a `sorry`-bodied helper until the Mathlib `Smooth ⟹ IsReduced`
    bridge lands)." This is housekeeping, not a gating issue.

## Severity summary

- **must-fix-this-iter**: none.
  - The helper `av_isIntegral_and_codimOneFree`'s `sorry` is declared a
    known issue in the directive and is not classified as must-fix
    per the directive's "Known issues" channel.
  - `extend_to_av` itself has a substantive (non-placeholder) proof body
    that structurally matches the blueprint sketch.
- **major**: none.
- **minor**:
  - Blueprint § Lean encoding could note the instance-resolution preamble
    + the `Smooth ⟹ IsReduced` Mathlib gap (housekeeping; not blocking).

Overall verdict: `extend_to_av`'s landed body matches the blueprint's
three-step combine-3.1-with-3.3 sketch in mathematical content and
structure; the residual `sorry` lives in the private helper documented in
the directive's "Known issues" block; no new red flags introduced this
iter.
