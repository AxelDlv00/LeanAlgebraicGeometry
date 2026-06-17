# Blueprint Writer Directive — `ratcurveiso-pin3-prose`

## Slug
ratcurveiso-pin3-prose

## Iteration
182

## Scope

Two chapters require precise updates this iter to consume iter-181
findings:

1. **`blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`** —
   update `lem:degree_one_morphism_iso` (Pin 3) statement block to
   match the iter-181 Lane I signature refinement. Also document the
   canonical `[Algebra K(C') K(C)]` instance convention at each
   call-site. Also surface the iter-182 plan-phase refactor of Pin 2
   (`lem:degree_via_pole_divisor`) — both new signature shape AND
   the new typed-sorry `Scheme.Hom.poleDivisor` declaration.

2. **`blueprint/src/chapters/RiemannRoch_OCofP.tex`** —
   add a small `\begin{definition}` block for
   `lineBundleAtClosedPoint.toFunctionField`, labelled
   `def:lineBundleAtClosedPoint_toFunctionField`, with
   `\lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}`,
   per the iter-181 `lean-vs-blueprint-checker iter181-ocofp` minor
   finding. Then update the `\uses{...}` of
   `lem:lineBundleAtClosedPoint_globalSections_iff` to include the
   new label.

## Strategic context

### Pin 3 (RationalCurveIso) signature refinement

iter-181 Lane I landed the following Lean signature for
`Scheme.iso_of_degree_one`:

```lean
theorem iso_of_degree_one
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C C' : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    [IsProper C'.hom] [SmoothOfRelativeDimension 1 C'.hom]
    [GeometricallyIrreducible C'.hom] [IsIntegral C'.left]
    (φ : C ⟶ C') (_hφ_non_const : ¬ IsConstant φ)
    [Algebra C'.left.functionField C.left.functionField]
    (_hφ_deg : Module.finrank C'.left.functionField C.left.functionField = 1) :
    IsIso φ := sorry
```

This replaces the iter-177 file-skeleton placeholder
`Nonempty (C'.functionField ≃+* C.functionField)` (which the
iter-181 mathlib-analogist consult `ratcurveiso-pins` Decision 2
classified as DIVERGE_INTENTIONALLY — strictly weaker than the
birational-extension body needs).

The chapter's current `lem:degree_one_morphism_iso` block (in
`RiemannRoch_RationalCurveIso.tex`) still pins `deg(φ) = 1` as the
hypothesis, with prose body discussing function-field iso via
"degree-1 finite extension is identity".

### Pin 2 (RationalCurveIso) signature strengthening (iter-182 plan-phase)

iter-182 plan-phase dispatched `refactor pin2-sig-strengthen` to
refactor the Pin 2 signature from the vacuous-in-`φ`
`∃ (d : ℕ) (D : C.left.WeilDivisor), 0 < d ∧ D.degree = (d : ℤ)`
into the substantive

```lean
theorem morphism_degree_via_pole_divisor
    {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    {C : Over (Spec (.of kbar))}
    [IsProper C.hom] [SmoothOfRelativeDimension 1 C.hom]
    [GeometricallyIrreducible C.hom] [IsIntegral C.left]
    (φ : C ⟶ ProjectiveLineBar kbar) (_hφ_non_const : ¬ IsConstant φ)
    [Algebra (ProjectiveLineBar kbar).left.functionField C.left.functionField] :
    ∃ (D : C.left.WeilDivisor),
        D = Scheme.Hom.poleDivisor φ ∧
        Scheme.WeilDivisor.degree D =
          (Module.finrank
            (ProjectiveLineBar kbar).left.functionField
            C.left.functionField : ℤ)
```

A new typed-sorry def `Scheme.Hom.poleDivisor` (analog of the iter-181
plan-phase `lineBundleAtClosedPoint.toFunctionField` pattern) is
introduced to carry the `φ^*[∞]` Weil divisor.

### OCofP `toFunctionField` pin

iter-181 plan-phase added the typed-sorry def
`AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField`
to OCofP.lean L154. The blueprint chapter
`RiemannRoch_OCofP.tex` discusses this as `ι : O_C(P) ↪ K_C` in three
places (L237-239, L247, L256-261) but does not have a `\lean{...}`
pin. The iter-181 lean-vs-blueprint-checker iter181-ocofp minor
finding recommends adding the pin.

## Required edits

### Edit 1 — `RiemannRoch_RationalCurveIso.tex` `lem:degree_one_morphism_iso` block

Update the statement to match the iter-181 Lean signature: replace
the `deg(φ) = 1` hypothesis prose with the explicit
`[K(C):K(C')] = 1` reformulation, citing
`Module.finrank C'.functionField C.functionField = 1`. Add a
parenthetical sentence noting that the
`[Algebra C'.functionField C.functionField]` instance at each
call-site is the canonical `φ`-induced function-field map (composite
of `Scheme.Hom.stalkMap` at the generic point with
`IsFractionRing.lift`), per `analogies/ratcurveiso-pin3.md`
Decision 2. The proof prose body (Hartshorne I.6.12 chain) does NOT
need to change — the substance is unchanged, only the hypothesis
shape.

Add a `% NOTE:` LaTeX comment line referencing
`analogies/ratcurveiso-pin3.md` (Decision 2,
`DIVERGE_INTENTIONALLY`) so future readers understand the signature
refinement provenance.

### Edit 2 — `RiemannRoch_RationalCurveIso.tex` `lem:degree_via_pole_divisor` block

Update the statement to match the iter-182 plan-phase refactored
Lean signature: explicitly tie `D = φ^*[∞]` (the pole divisor) and
`deg(D) = [K(C):k̄(ℙ¹)]` in the output existential. Add a
parenthetical sentence noting that `φ^*[∞]` is exposed in Lean as
`Scheme.Hom.poleDivisor φ` (a new typed-sorry def in
`RationalCurveIso.lean`; body landing iter-183+ via affine-chart
`Ideal.sum_ramification_inertia`). The proof prose body is unchanged
(Hartshorne II.6.9 multiplicativity).

### Edit 3 — `RiemannRoch_OCofP.tex` add `def:lineBundleAtClosedPoint_toFunctionField`

After the existing `def:lineBundleAtClosedPoint` block (and BEFORE
the `lem:lineBundleAtClosedPoint_globalSections_iff` block), insert:

```latex
\begin{definition}[Inclusion of $\mathcal O_C(P)$ into the function field]
  \label{def:lineBundleAtClosedPoint_toFunctionField}
  \lean{AlgebraicGeometry.Scheme.lineBundleAtClosedPoint.toFunctionField}
  \uses{def:lineBundleAtClosedPoint}
  % SOURCE: Hartshorne, II.6, "Cartier divisors"
  % SOURCE QUOTE: ... (write the actual verbatim text from references/hartshorne-graduate.pdf)
  \textit{Source: Hartshorne, II.6.}
  Informal statement of the canonical inclusion
  $\iota : \mathcal O_C(P) \hookrightarrow \mathcal K_C$ as a
  $k$-linear map of global sections.
\end{definition}
```

**You may need a child `reference-retriever` dispatch** if the
`hartshorne-graduate.pdf` is not yet present at `references/`. Check
first with `ls references/hartshorne*`; if absent, dispatch the
retriever (your `--write-domain` includes `references/**` for
exactly this purpose). If the retriever returns NOT_FOUND, leave the
SOURCE QUOTE flagged as `(verbatim text not yet retrieved)` per the
plan.md anti-fabrication rule.

Then update the `\uses{...}` line of
`lem:lineBundleAtClosedPoint_globalSections_iff` to include
`def:lineBundleAtClosedPoint_toFunctionField`.

## Out of scope

- Adding `\leanok` / `\mathlibok` markers (deterministic
  `sync_leanok` phase manages `\leanok`; review agent manages
  `\mathlibok`).
- Editing any chapter other than the two named above.
- Touching `archon-protected.yaml` (no protected signatures
  affected — verified).
- Filling proof bodies in Lean files.

## Strategy-modifying findings

None expected; the two chapter edits are direct consequences of the
iter-181 Lane I refinement, the iter-182 plan-phase Pin 2 refactor,
and the iter-181 lean-vs-blueprint-checker iter181-ocofp minor
finding. Report back if you discover a strategic ambiguity that
requires STRATEGY.md update.
