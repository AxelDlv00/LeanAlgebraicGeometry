# Strategy Critic Directive

## Slug
iter121

## Project goal

The project formalizes Christian Merten's Jacobian challenge: nine
protected declarations (signatures frozen) covering:

- `AlgebraicGeometry.genus` (Genus.lean)
- `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`,
  `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`,
  `Jacobian.instGeometricallyIrreducible` (Jacobian.lean)
- `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
  `Jacobian.exists_unique_ofCurve_comp` (AbelJacobi.lean)

These together define the Jacobian (Albanese) variety of a smooth proper
geometrically irreducible curve over a field and its universal Abel–Jacobi
mapping property. As of iter-121 the project's autonomous-loop end-state
is **zero inline `sorry`** — every previously-deferred Mathlib gap is now
on the active roadmap (per the iter-121 user directive: the loop now
operates as a Mathlib contributor, filling each missing piece in-tree at
Mathlib-merge quality rather than treating it as project-external).

## Strategy under review

<paste of STRATEGY.md follows>

```
# Strategy

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only
on them.

## End-state (iter-121 pivot)

The earlier iterations operated under a "ship with one inline `sorry`"
end-state, treating each remaining Mathlib gap as project-external and
documented-but-deferred. **Per the iter-121 user directive, this framing
is dropped**: the project's autonomous loop now operates as a Mathlib
contributor, building each missing piece directly in-tree at
Mathlib-merge quality and removing the corresponding `sorry`. There are
no deferred tasks; every gap is on the active roadmap.

The end-state is **zero inline `sorry` in the project**. Each currently
deferred Mathlib build-out is on the roadmap below with its own decomposed
sub-step list and a per-step estimate of iterations and LOC. The roadmap
is multi-month; each iteration's `PROGRESS.md` schedules the next concrete
sub-step.

## Current sorry inventory

| Site | Status | Roadmap section |
|---|---|---|
| `Differentials.lean` — `smooth_locally_free_omega` | closed iter-120 | — |
| `Differentials.lean` — bridge `relativeDifferentialsPresheaf` → algebra-Kähler | **NEW (iter-121)** declaration to be introduced | § Roadmap M1 |
| `Jacobian.lean:179` — `nonempty_jacobianWitness` | open | § Roadmap M2 / M3 |

The bridge declaration is added to the active sorry inventory this iter
because closing it was previously deferred as "out-of-autonomous-loop
scope"; under the new strategy it is in scope, with the decomposition
below as the work plan.

## Roadmap

The roadmap lists the Mathlib build-outs the project must execute, in
the order of increasing scope. Each milestone is decomposed into
sub-steps with effort estimates. Effort estimates are loop-iter counts
(one prover iter ≈ one focused sub-step closure) plus a rough total
LOC for the milestone.

### M1 — Bridge: presheaf ↔ algebra-Kähler form on an affine chart

**Estimated cost.** 4–7 iter / 250–450 LOC.

**Statement.** Let `f : X ⟶ S` be a morphism of schemes, `U : S.Opens`
and `V : X.Opens` affine opens with `V ≤ f ⁻¹ᵁ U`. Write
`A := Γ(S, U)`, `B := Γ(X, V)`, with the appLE algebra structure
`A → B` induced by `f`. Then the section module of the relative
cotangent presheaf at `V` is canonically `B`-linearly isomorphic to
the appLE-algebra Kähler module:

```
(relativeDifferentialsPresheaf f).presheaf.obj (.op V)  ≃ₗ[B]  Ω[B ⁄ A]
```

**Decomposition** (informally; the prover decides the exact Lean
shape). Write `A_colim := (f⁻¹_psh O_S)(V) =
colim_{W : f V ⊆ W ⊆ S} O_S(W)` for the inverse-image presheaf
section ring on `V`. The bridge factors as:

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M1.a | The multiplicative set `M := {g ∈ A : appLE(g) ∈ B^×}` is a submonoid of `A` | `Submonoid.mk` | 1 iter / 30 LOC |
| M1.b | `A → A_colim` is a localization at `M` (`IsLocalization`); equivalently, `A_colim ≃ₐ[A] Localization M` | cofinality of `{D(g) : g ∈ M}` in `{W : f V ⊆ W}` plus `IsAffineOpen.basicOpen_isLocalization`; `TopCat.Presheaf.pullback` cofinality lemma (new contribution) | 2 iter / 120 LOC |
| M1.c | `Ω[A_colim/A] = 0` and the projection `Ω[B/A] → Ω[B/A_colim]` is a `B`-linear iso | `KaehlerDifferential.isLocalizedModule_map` (Mathlib `RingTheory.Etale.Kaehler`), `Subsingleton` of `KaehlerDifferential` of a localization | 1 iter / 60 LOC |
| M1.d | Identify `Ω[B/A_colim]` with the presheaf section module via the `rfl`-style identification `relativeDifferentialsPresheaf_obj_kaehler` | local rewrite | 1 iter / 30 LOC |
| M1.e | Assemble the `B`-linear iso `(relativeDifferentialsPresheaf f).presheaf.obj (.op V) ≃ₗ[B] Ω[B ⁄ A]` and integrate it with `smooth_locally_free_omega` to produce the presheaf-form forward criterion | none new | 1 iter / 40 LOC |

The cofinality step M1.b is the heart of the milestone and the genuine
Mathlib contribution candidate: it identifies a directed colimit of
basic-open section rings with the localization at the multiplicative
set of "good" elements. The same lemma will be useful in many other
Mathlib contexts (inverse-image presheaves on affine charts), so the
M1.b sub-step is worth landing as a standalone, reusable result —
candidate location:
`Mathlib.AlgebraicGeometry.Presheaf.InverseImage` or
`Mathlib.AlgebraicGeometry.Morphisms.Cofinality` (new file).

### M2 — Genus-$0$ witness via rigidity (Route C, partial)

**Estimated cost.** 4–8 iter / 200–500 LOC for the rigidity-and-trivial-
witness pieces; an additional 5–10 iter for the `C ≅ ℙ¹_k`
identification if the project decides to take it on (depends on
M2.c availability).

**Statement.** When `genus C = 0`, the Albanese witness for `C` may be
constructed with underlying scheme `J = Spec k`. The genus-0 universal
property reduces to rigidity (`Hom(ℙ¹_k, A) = A(k)` for `A` a smooth
proper geometrically irreducible group scheme) plus the genus-0
identification `C ≅ ℙ¹_k`.

**Decomposition.**

| Step | Math content | Mathlib leverage | Est. |
|---|---|---|---|
| M2.a | Rigidity for `ℙ¹_k → A`: any morphism from `ℙ¹_k` to a smooth proper geometrically irreducible group scheme `A` that hits the identity at a $k$-rational point is constant | The project's existing `GrpObj.eq_of_eqOnOpen` (Rigidity.lean) restricted to `X = ℙ¹_k` | 2–3 iter / 100 LOC |
| M2.b | Genus-0 witness for `Spec k`: define a `JacobianWitness` whose underlying scheme is `Spec k`, group structure is trivial, smoothness/properness/geometric-irreducibility/genus-relative-smoothness are kernel-only, and `isAlbaneseFor` uses M2.a | New project material | 2 iter / 80 LOC |
| M2.c | Genus-0 identification `C ≅ ℙ¹_k`: a smooth proper geometrically irreducible curve over $k$ with a $k$-rational point and $\genus C = 0$ is isomorphic to `ℙ¹_k` | Requires `H⁰(C, O_C(P)) = 2` (Riemann-Roch consequence). Mathlib `b80f227` has no Riemann-Roch in usable form for the project's genus-via-Ext definition | 5–10 iter / 200–400 LOC (deferred subject to M2.c feasibility audit) |

M2.a and M2.b are independent of M2.c and can be executed now; they
deliver a genus-0 witness conditional on `C ≅ ℙ¹_k`. M2.c is gated on
either a Mathlib Riemann-Roch contribution or a project-internal
proof using the existing Čech cohomology + finite-dimensional machinery
(both heavy).

### M3 — General witness via Picard scheme or symmetric powers

**Estimated cost.** Many tens of iters / thousands of LOC; multi-month.

This is the genuinely heavy build-out. Two equally hard routes:

- **Route A — Picard scheme via FGA.** Hilbert schemes, Quot schemes,
  representability of the Picard functor for smooth proper
  geometrically connected curves, identity-component construction.
- **Route B — Symmetric powers + Stein factorisation.** Scheme-level
  symmetric powers, finite-group-scheme quotients (with smoothness),
  Brill-Noether-Riemann-Roch, Stein factorisation for proper morphisms
  with coherent cohomology.

Each route's sub-step inventory matches the blueprint chapter
`Jacobian.tex § "Existence of an Albanese variety"`. The project will
pick one route and execute it. **Route choice is deferred to a future
iteration's plan-phase** (decision point: after M1 and M2.a/b complete,
audit each route's then-current Mathlib snapshot dependencies).

The project's autonomous-loop ambition is to land M3 in-tree over the
multi-month roadmap; intermediate iters may target Mathlib upstream
PRs if a sub-piece is clearly more useful as an upstream contribution
than a project-internal one (e.g. Hilbert scheme infrastructure).

## What ships unconditionally (current snapshot)

These files compile end-to-end with no `sorryAx` in their axiom chains
as of iter-120 close:

- `Rigidity.lean` — Mumford rigidity for pointed proper smooth morphisms.
- `Genus.lean` — `genus C := Module.finrank k (Scheme.HModule k (Scheme.toModuleKSheaf C) 1)`.
- `Cohomology/SheafCompose.lean` / `StructureSheafAb.lean` /
  `StructureSheafModuleK.lean` / `MayerVietorisCore.lean` /
  `MayerVietorisCover.lean` — the Čech / Mayer–Vietoris infrastructure
  consumed by `Genus.lean`.
- `Differentials.lean` (current declarations) —
  `relativeDifferentialsPresheaf` definition,
  `relativeDifferentialsPresheaf_obj_kaehler` identification,
  `smooth_locally_free_omega` forward direction (algebra-Kähler form).
  The bridge declaration introduced by iter-121 will hold a `sorry`
  body during the M1 work and is the new sorry-bearing entry in this
  file.

The protected `genus` and `Rigidity` are unconditional.

## What ships against the single witness (current snapshot)

The protected `Jacobian`-arc declarations (`Jacobian.lean` +
`AbelJacobi.lean`) all `lean_verify` to `sorryAx` rooted at
`Jacobian.lean:179`. Until M2 (genus-0) and M3 (general) deliver, this
remains. The framework around the Albanese variety (group-object
structure, smoothness of relative dimension `g`, properness, geometric
irreducibility, the Abel–Jacobi map, and the universal property) is in
place; only the existence witness is open.

## Soundness rules

- **No new axioms.** Every closed declaration must `lean_verify` to
  kernel-only axioms (`propext, Classical.choice, Quot.sound`).
- **No "deferred" framing.** Mathlib gaps are decomposed into the
  roadmap above with concrete sub-step estimates; the planner does
  not write "out-of-autonomous-loop scope" sections anymore. If a
  sub-step is genuinely outside the loop's reach (e.g. requires a
  multi-month upstream contribution), it is recorded in the roadmap
  with an explicit "blocked on upstream X" note and a fallback
  iter-by-iter approach that progresses the surrounding sub-steps.
- **Converse of `smooth_locally_free_omega` is mathematically false.**
  The counterexample `Spec k → Spec k[t]` via `t ↦ 0` (locally of
  finite presentation, `Ω = 0` everywhere locally free, but not flat
  hence not smooth) breaks the bare local-freeness-of-Ω implication.
  The true converse needs `Subsingleton (Algebra.H1Cotangent A B)`
  (formal smoothness via vanishing André–Quillen `H¹`). The blueprint
  chapter `Differentials.tex` discloses this honestly; we do not
  state the false iff. **This is not a deferred task** — it is a
  correctness correction; there is no "true theorem" to defer to,
  just a strictly-stronger Mathlib lemma
  `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential` that the
  project may eventually wire up as a scheme-level converse-with-
  extra-hypothesis result. That counts as a future roadmap entry
  (M4) if and when a downstream consumer needs it.

## Mathlib gap inventory (live)

The roadmap above absorbs every gap previously labelled "Mathlib gap"
into a concrete milestone. For clarity:

- **Gap (bridge)**: subsumed by milestone M1.
- **Gap (genus-0 identification)**: subsumed by milestone M2.c (gated).
- **Gap (Hilbert/Quot/FGA)**: subsumed by milestone M3 Route A.
- **Gap (symmetric powers / Stein factorisation)**: subsumed by
  milestone M3 Route B.
- **Gap (converse of smoothness criterion)**: optional future M4,
  driven by downstream consumer demand.

All gaps are in-scope; none are project-external. The loop's job is
to execute the roadmap, one sub-step per iter, recording PARTIAL
progress in `PROGRESS.md` and the iter sidecar as each sub-step
advances.
```

## References index

```
# References

<!-- archon:references-summary -->

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

- `blueprint/src/chapters/AbelJacobi.tex` — Protected `Jacobian.ofCurve`, `comp_ofCurve`, `exists_unique_ofCurve_comp`; per-point projection of `jacobianWitness`'s `isAlbaneseFor` field.
- `blueprint/src/chapters/Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES + affine-cover infrastructure for `HModule` cohomology of curves; consumed by `Genus.lean`.
- `blueprint/src/chapters/Cohomology_SheafCompose.tex` — `HasSheafCompose` instances for forget functors between sheaf categories.
- `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — Structure-sheaf side of `O_X`-modules into `AddCommGrp`.
- `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — Stein-finiteness for `Γ(X, O_X)` and global-sections over the residue field; closes the Čech-cohomology-finite-dimensionality chain that defines `genus`.
- `blueprint/src/chapters/Differentials.tex` — Relative cotangent presheaf, `smooth_locally_free_omega` forward direction, bridge to algebra-Kähler form (M1 milestone), converse counterexample.
- `blueprint/src/chapters/Genus.tex` — Definition of `genus C := finrank k (HModule k (toModuleKSheaf C) 1)`; consumes the Mayer–Vietoris + Čech infrastructure.
- `blueprint/src/chapters/Jacobian.tex` — Albanese universal property, JacobianWitness bundle, the three classical existence routes (Picard / symmetric powers / genus-0+rigidity) decomposed into per-route Mathlib gap inventories.
- `blueprint/src/chapters/Modules_Monoidal.tex` — Monoidal structure on Scheme presheaf-modules (orphan; consumer-less leaf).
- `blueprint/src/chapters/Picard_Functor.tex` — Relative Picard functor as contravariant set-valued functor.
- `blueprint/src/chapters/Picard_FunctorAb.tex` — Additive wrapper for Picard functor.
- `blueprint/src/chapters/Picard_LineBundle.tex` — `LineBundle = CommRing.Pic`-approximation.
- `blueprint/src/chapters/Rigidity.tex` — Mumford rigidity for pointed proper smooth morphisms.

## Prior critique status

Iter-120 strategy-critic returned CHALLENGE on Phase C Step 5 (claimed
`rfl` bridge that did not exist). Iter-120 plan adopted the
strategy-critic's Option (iii) recommendation: refactor
`smooth_locally_free_omega` to algebra-Kähler form, deferring the
bridge. Iter-121 reverses the deferral per user directive: the bridge
is now M1.

The other live concern from iter-120 was the **`nonempty_jacobianWitness`
axiomization challenge** ("the witness is an existence hypothesis, not
a theorem; should it be an axiom rather than `sorry`?"). The
plan-phase rebuttal stood. Iter-121 changes the answer entirely: the
witness is no longer deferred / hypothetical; it is M2 (genus-0
sub-case) and M3 (general). No axiomization on either.

Please re-verify the iter-121 strategy with full freshness; do not
defer to the prior critique's resolution where the strategy has
changed.
