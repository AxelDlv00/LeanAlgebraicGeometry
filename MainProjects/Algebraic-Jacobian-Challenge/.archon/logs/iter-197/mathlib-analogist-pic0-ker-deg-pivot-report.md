# Mathlib Analogist Report

## Mode
api-alignment

## Slug
pic0-ker-deg-pivot

## Iteration
197

## Question

Should the project pivot from `Pic⁰_{C/k} := IdentityComponent (PicScheme C)`
(parked ~4 iters on Stacks 04KU/04KV, ~0/iter velocity) to
`Pic⁰_{C/k} := ker(deg : Pic_{C/k} → ℤ_{C/k})` (A.3.vii)?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Underlying scheme of `Pic⁰_{C/k}` (identity-component vs degree-stratification) | STRUCTURAL_OK (pivot recommended) | high-stakes |
| Mathlib idiom for `GrpObj.ker` on group schemes | NEEDS_MATHLIB_GAP_FILL (sidestepped — curve case avoids generic kernel) | informational |
| Equivalence `ker(deg) = identity component` for smooth proper geom. integral curves | CONFIRMED (Kleiman §6 `ex:curves` + Milne III.1) | informational |

## Overall verdict

**STRUCTURAL_OK — pivot recommended.** The literature (Kleiman §6
`ex:curves`, line 4665 of `references/kleiman-picard-src/kleiman-picard.tex`;
Milne *Abelian Varieties* III.1 p.~87 / PDF p.~93) directly identifies
`Pic⁰_{C/k}` with the degree-0 open-and-closed subscheme of
`Pic_{C/k}` for the project's hypothesis (smooth proper geometrically
integral curve). Mathlib b80f227 has NO direct idiom for either path —
neither `IdentityComponent` for group schemes nor `GrpObj.ker` —
but the degree-stratification path piggybacks on Kleiman's Hilbert-
polynomial decomposition (`thm:Pphifin`), which the project already
plans to build for A.3.vii regardless. The pivot saves ~10–18 iters
and removes the unbounded-park risk on Stacks 04KU/04KV.

## Concrete iter-198+ workplan

1. **Repurpose `Picard/IdentityComponent.lean`** (or split into
   `Picard/IdentityComponent.lean` + `Picard/Pic0ByDegree.lean`).
   Keep `GroupScheme.IdentityComponent` substrate (abstract; no
   urgency to close its sorries).

2. **Build Kleiman `thm:Pphifin` / `ex:curves` substrate** in a new
   `PicScheme.degComp` namespace:
   ```lean
   noncomputable def PicScheme.degComp {k : Type u} [Field k]
       (C : Over (Spec (.of k)))
       [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
       [GeometricallyIntegral C.hom]
       (d : ℤ) : Over (Spec (.of k))

   noncomputable def PicScheme.degComp.ι {k : Type u} [Field k]
       (C : Over (Spec (.of k))) [...] (d : ℤ) :
       PicScheme.degComp C d ⟶ PicScheme C
   ```
   Open-and-closed inclusion from Kleiman `thm:Pphifin`.

3. **Redefine `Pic0Scheme C := PicScheme.degComp C 0`**. The TYPE
   stays `Over (Spec (.of k))`, so downstream consumers in
   `Pic0AbelianVariety.lean` and `Albanese/AlbaneseUP.lean` are
   ABI-preserving (confirmed: those files use only
   `(Pic0Scheme C).left`, `(Pic0Scheme C).hom`, and the name
   `Pic0Scheme C`).

4. **Inherit `GrpObj (Pic0Scheme C)`** from `PicScheme C` via the
   identity `deg(L ⊗ M) = deg L + deg M` (~30–50 LOC).

5. **The "Pic⁰ = identity component" equivalence** becomes a
   deferrable theorem (currently informally captured by
   `Pic0Scheme.kPoints_iff_kerDegree`), provable when Stacks 04KU/04KV
   land in Mathlib. It is OFF the critical path for
   `nonempty_jacobianWitness`.

### Estimated LOC

- Pivot path (Kleiman `thm:Pphifin` decomposition + Pic⁰ assembly):
  **~130–245 LOC** total, of which ~80–150 LOC is the A.3.vii
  substrate the project ALREADY budgets.
- Replaces ~350 LOC parked identity-component path (currently
  blocked on Mathlib substrate not in b80f227).
- Net iter savings: **~10–18 iters**.

### One residual caveat

`Pic0.geometricallyIrreducible` in `Pic0AbelianVariety.lean` is the
single statement where identity-component theory is genuinely
load-bearing — Kleiman `prp:pic0` derives geom-irreducibility from
the connected-component-of-a-smooth-group-scheme structure. Under the
pivot, this becomes ONE conjunct of the four in `Pic0.isAbelianVariety`
that still needs Stacks 04KU substrate (or `Pic⁰ = Pic^τ` finiteness),
but it no longer BLOCKS the definition of `Pic0Scheme` or the bulk of
downstream construction. This converts 04KU from "blocks the whole
positive-genus arm" to "blocks one conjunct of the assembly statement"
— a strict improvement.

## Major

(omitted — no ALIGN_WITH_MATHLIB verdict applies)

## Must-fix-this-iter

(omitted — the parked A.3.i shipped code is the SUBJECT of the pivot;
"must-fix" applies once the pivot is sanctioned, but the verdict here
is STRUCTURAL_OK not ALIGN_WITH_MATHLIB)

## Informational

- **Kleiman §6 `ex:curves` (line 4665 of
  `references/kleiman-picard-src/kleiman-picard.tex`)** explicitly
  identifies `Pic^0_{X/S}` (degree-0) with the connected component of
  the identity for curves with integral geometric fibers, and shows
  each `Pic^m_{X/S}` is an fppf-torsor over `Pic^0_{X/S}`. This is
  the literature anchor for the pivot.
- **Milne III.1 p.~87** (`references/abelian-varieties.pdf`, PDF
  p.~93) defines `Pic^0(C)` as "the group of isomorphism classes of
  invertible sheaves of degree zero" and observes "both `Pic^0(C)`
  and `Pic^r(C)` are fibres of the map `deg : Pic(C) → ℤ`". Milne's
  Theorem 1.6 then represents this functor by an abelian variety
  (the Jacobian) directly, with no detour through identity-component
  theory.
- **Mathlib b80f227 inventory**:
  - `MonoidHom.ker` (Type / `Subgroup G`) — not applicable at scheme
    level.
  - `AlgebraicGeometry.Scheme.Hom.ker` — produces `IdealSheafData`,
    a different concept (kernel ideal sheaf, not the categorical
    kernel of a group-scheme morphism).
  - `CategoryTheory.Limits.kernel` — requires `HasZeroMorphisms`;
    `Scheme` is cartesian-monoidal, not abelian, so doesn't fire.
  - `CategoryTheory.GrpObj` — provides the group-object structure
    that the project uses for `PicScheme C`, but does not package a
    kernel construction.
  - **No `GrpObj.ker` exists in Mathlib b80f227.** The project does
    not need one; the curve-case Pic⁰ is the degree-0 connected
    component, derived from Kleiman's Hilbert-polynomial
    decomposition without invoking a generic categorical kernel.
- **`MonoidHom.fiberEquivKer`** captures the conceptual insight
  ("kernel = fiber over identity"), useful for justifying the
  ker(deg) framing but not directly portable to schemes.

## Persistent file
- `analogies/pic0-ker-deg-pivot.md` — full structural analysis,
  literature citations with line numbers, Mathlib inventory,
  cost/iter estimates, residual-caveat notes.

Overall verdict: pivot to ker(deg) Pic⁰ via Kleiman §6 degree-
stratification is STRUCTURAL_OK, mathematically backed by
Kleiman `ex:curves` + Milne III.1, and saves ~10–18 iters vs the
parked Stacks 04KU/04KV identity-component path.
