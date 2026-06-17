# Strategy

## End-state

`AlgebraicJacobian/Genus.lean`, `Jacobian.lean`, `AbelJacobi.lean` compile with **no `sorry`** and **no new `axiom`**, and the nine declarations frozen by `archon-protected.yaml` carry their intended mathematical content:

- `genus C` = the genus of a smooth proper geometrically irreducible curve `C` over a field `k`.
- `Jacobian C : Over (Spec (.of k))` = the connected component of the identity in the Picard scheme of `C`, equipped with `GrpObj`, `IsProper`, `GeometricallyIrreducible`, and `SmoothOfRelativeDimension (genus C)`.
- `ofCurve P : C ⟶ Jacobian C` = the Abel–Jacobi map for a `k`-rational point `P`, sending `P` to `η[Jacobian C]`, and satisfying the Albanese universal property.

## Honest assessment of feasibility (Mathlib b80f227, Lean 4.30.0-rc2)

A full Mathlib survey (see `task_pending.md`) shows that **every single one of the nine protected declarations is blocked by non-trivial missing Mathlib infrastructure** — the gap is not in the proofs, it is in the surrounding theory. In particular:

| Theory needed | Mathlib status |
|---|---|
| Sheaf cohomology of quasi-coherent sheaves on schemes (`Hⁱ(X, F)`) | absent (only `EllAdicCohomology` and abstract `RightDerived` machinery) |
| Sheaf of relative Kähler differentials `Ω_{X/S}` of schemes | absent (rings only) |
| Picard scheme / Picard functor / `Pic⁰` | absent (only `CommRing.Pic R`) |
| Hilbert polynomial of a coherent sheaf, arithmetic genus | absent |
| Riemann–Roch, Serre duality, rigidity for abelian varieties, Albanese | absent |
| Abelian variety / abelian scheme as a defined object | absent (encoded ad hoc via `[GrpObj] [IsProper] [GeometricallyIrreducible]`) |

What **is** in Mathlib and we can lean on: `SmoothOfRelativeDimension`, `IsProper`, `GeometricallyIrreducible`, `Smooth`, `GrpObj` (with `instTensorUnit : GrpObj (𝟙_ C)`), `MonObj`, `η[·]`, the cartesian-monoidal structure on `Over (Spec (.of k))`, `Mathlib/AlgebraicGeometry/Group/Abelian.lean` (commutativity of proper geometrically integral group schemes — Stacks 0BFD), `KaehlerDifferential` for rings.

This means **no honest local proof effort closes the protected declarations in this Mathlib**. We must not paper over the gap with ad-hoc definitions, weakened hypotheses, or new axioms (forbidden by the plan-agent rules). The path to completion is to **build the missing Mathlib chapter** ourselves inside this project, in the order forced by the dependency tree.

## Path from today to the end-state

The work decomposes into five phases. Phases A–C are *infrastructure* (new content this project must introduce); D–E are the protected definitions and theorems on top.

### Phase A — Coherent sheaf cohomology on schemes  (revised iter-004: ≥ 8 iterations / ≥ 600 LOC for the abelian-group level; ≥ 20 further iterations / ≥ 1500 LOC for the $k$-vector-space level + Serre finiteness)

The iter-004 Mathlib probe showed that the abelian-group-level definition of $H^n(C, \mathcal O_C)$ is reachable from existing Mathlib API via the chain `HasSheafCompose → HasSheafify → HasExt → Sheaf.H`; only the structure-sheaf-as-Ab-sheaf wiring is new. After iter-004's `Cohomology/StructureSheafAb.lean` lands (steps 2–4 wiring), the remaining work splits into:

- step 5: $\Module k$ structure on $H^1(C, \mathcal O_C)$ via the $k$-algebra structure on $\Gamma(C, \mathcal O_C)$. New mathematical content but not deep — likely 1–2 iterations.
- step 6: Serre finiteness (finite-dimensionality of $H^i(C, \mathcal F)$ for coherent $\mathcal F$ on a proper $k$-scheme). Deep, requires non-trivial commutative-algebra / cohomology infrastructure. Likely 5–10 iterations even with Mathlib's existing Čech-cohomology and module-theory APIs.

Mathlib gaps that genuinely remain: Serre's vanishing theorem for proper schemes (no analogue in `b80f227`), and the link between `Sheaf.H` (abstract Grothendieck-topology cohomology) and the more classical Čech / sheaf-of-modules cohomology that supports the finiteness arguments.

### Phase B — Sheaf of relative differentials  (≥ 10 iterations, ≥ 800 LOC)

`Scheme.Ω` (relative cotangent sheaf), via globalising `KaehlerDifferential`. Smoothness ↔ locally free `Ω`; rank equals relative dimension.

### Phase C — Picard functor and its representability for curves  (≥ 30 iterations, ≥ 2500 LOC)

Define `PicardFunctor C : SchemeOver k ⥤ AddCommGrp` as `S ↦ Pic(C ×_k S)/Pic(S)`, étale-sheafify, and prove representability for `C` smooth proper geometrically connected of relative dimension 1. Connected component `Pic⁰_{C/k}`, smoothness, properness, geometric irreducibility, dimension equals genus.

This phase is the hardest. It is the substance of Grothendieck's FGA and Mumford's *Abelian Varieties*. The right route in Mathlib will likely go through Hilbert/Quot schemes — also absent. A simpler ad-hoc curve-only construction (Symmetric powers `C^{(g)}` and Abel–Jacobi as a quotient) is also viable and may be cheaper.

### Phase D — `genus`, `Jacobian`, `instGrpObj`, and the curve typeclasses (5–10 iterations)

Once A–C are in, the four protected declarations in `Genus.lean`/`Jacobian.lean` are short:

- `genus C := Module.finrank k ((Scheme.toAbSheaf C).H 1)`, using the iter-004 `Scheme.toAbSheaf` and Mathlib's `Sheaf.H` (the $\Module k$ structure on $H^1$ comes from Phase A step 5).
- `Jacobian C := Pic⁰ C` (the representing scheme from Phase C).
- `instGrpObj`, `instIsProper`, `instGeometricallyIrreducible`, `smoothOfRelativeDimension_genus` follow directly from the representability theorem and the dimension formula in Phase C.

### Phase E — Abel–Jacobi and Albanese property  (5–10 iterations)

`ofCurve P` is the morphism `C → Pic⁰ C, Q ↦ [O_C(Q − P)]`, formalised through the universal property of `Pic⁰` once we have a divisor-line-bundle dictionary. `comp_ofCurve` is direct from the construction. `exists_unique_ofCurve_comp` (Albanese) uses the rigidity theorem for morphisms between abelian varieties (Mumford §4) — a self-contained sub-project of ~5–10 lemmas.

## Steps that may proceed in parallel

- B is independent of A on the cohomology side and can be developed simultaneously, sharing the locally-free / quasi-coherent sheaf infrastructure built in A.
- The Albanese rigidity lemmas (preamble to E) can be proved from the existing `Mathlib/AlgebraicGeometry/Group/Abelian.lean` while A–C proceed.
- Within C, the symmetric-power side and the line-bundle-dictionary side can advance in parallel.

Phases D and E are strictly sequential after C.

## Refactors implied

None of the protected signatures need to change — the issue is upstream infrastructure, not signatures. Once Phase A produces a stable scheme-cohomology API, we will likely **introduce new files** (e.g. `AlgebraicJacobian/Cohomology/Basic.lean`, `AlgebraicJacobian/Picard/Functor.lean`, `AlgebraicJacobian/Picard/Representability.lean`, `AlgebraicJacobian/AbelianVariety/Rigidity.lean`) and add corresponding blueprint chapters. Each new file split will be requested via `REFACTOR_DIRECTIVE.md` only after the blueprint chapter for the new material is in place.

## Where we currently sit (iter 004)

After iter 003 the project has every Phase A / B / C step that can be reached without genuinely new mathematics: a Phase E rigidity helper (iter-002), a Phase B/C step 1 `LineBundle / Pic / Pic.pullback` API closed under a documented first-approximation (iter-002), the Phase A step 1 `HasSheafCompose` instance (iter-003), and the Phase C step 2 relative Picard functor *definition* (iter-003) with its FGA-level representability theorem deferred. The 9 protected sorries remain unchanged.

A live Mathlib probe in iter 004 has produced a major **strategy update**: Phase A steps 2–3 (`HasSheafify` and `HasExt` on $\Sheaf(\opens X, \AddCommGrpCat)$) are **already in Mathlib** — `HasSheafify` succeeds via `infer_instance` with universe pinning, `HasExt` follows from `HasExt.standard` plus the abelian instance on the sheaf category. Together with the iter-003 `HasSheafCompose`, this collapses Phase A's remaining work to: step 4 (structure-sheaf-as-Ab-sheaf wiring, easy), step 5 ($\Module k$ structure on $H^1$, real but small), and step 6 (Serre finiteness, deep). The original honest-assessment figure of "≥ 30 iterations / ≥ 2000 LOC for Phase A" overstates the gap on steps 2–4 and undersells how reachable the abelian-group level definition of $H^n(C, \mathcal O_C)$ now is; the genuine bottleneck is steps 5–6.

Iter 004 (refactor) therefore opens two parallel helper tracks: Phase A steps 2–4 wiring (single new file `Cohomology/StructureSheafAb.lean`) and Phase C step 3 codomain change (single new file `Picard/FunctorAb.lean`). The forthcoming prover round is expected to close all four helper sorries with mostly typeclass plumbing and `AddCommGrpCat.ofHom` boilerplate.

The protected sorries continue to be off-limits until the upstream chains land: `genus` after Phase A steps 5–6, `Jacobian` after Phase C representability (gated by both `LineBundle` refinement and the FGA argument), `ofCurve / comp_ofCurve / exists_unique_ofCurve_comp` after Phase C and Phase E.

## Revision log

- iter 001 — initial strategy written; honest assessment that protected declarations are blocked behind ~3 missing Mathlib chapters (scheme cohomology, sheaf of differentials, Picard scheme); five-phase build-out plan.
- iter 002 — strategy unchanged in substance. Iter 001 discovery confirmed every gap; refactor scaffolds two helper files (`Rigidity.lean` for Phase E rigidity, `Picard/LineBundle.lean` for Phase B/C step 1) with new blueprint chapters, leaving the 9 protected sorries untouched until the upstream phases land. Both closed by the iter-002 prover round (sorry count `13 → 9`).
- iter 003 — strategy unchanged in substance. Refactor scaffolds two new helper files: `AlgebraicJacobian/Cohomology/SheafCompose.lean` (Phase A step 1) and `AlgebraicJacobian/Picard/Functor.lean` (Phase C step 2 — relative Picard functor + bundled representability sorry). Both *definition* sorries closed by the iter-003 prover round: `instHasSheafCompose_…` honestly via `Limits.comp_preservesLimits` + `hasSheafCompose_of_preservesLimitsOfSize`; `PicardFunctor` honestly via 8 helper lemmas (`fiberMap`, `quotMap`, …) on the iter-002 `Pic.pullback` API. Source-category change `Schemeᵒᵖ → (Over (Spec k))ᵒᵖ` documented. `representable` deferred. Sorry count `9 → 12 → 10`.
- iter 004 — **strategy substantively updated.** Live Mathlib probe shows Phase A steps 2–3 are already inferable from existing Mathlib API (with universe pinning); the original "≥ 30 iterations / ≥ 2000 LOC" estimate for Phase A overstates the gap on steps 2–4. Refactor accordingly scaffolds two new helper files: `AlgebraicJacobian/Cohomology/StructureSheafAb.lean` (Phase A steps 2–4 wiring: `HasSheafify`, `HasExt`, `Scheme.toAbSheaf`) and `AlgebraicJacobian/Picard/FunctorAb.lean` (Phase C step 3 codomain change: `AddCommGrpCat`-valued variant of `PicardFunctor`). The étale-sheafification step proper (Phase C step 3) remains blocked by the genuine Mathlib gap `HasWeakSheafify Scheme.etaleTopology AddCommGrpCat` (verified by `lean_run_code`); not in scope. After iter-004's prover round closes the four new sorries, the project will be one $\Module k$-on-$H^1$ + one Serre-finiteness step away from an honest `genus`, and one étale-sheafification + FGA representability step away from `Jacobian`.
