# Strategy-critic directive — slug `route173`

## Mode

Re-verification of post-iter-172 restructure.

## Input

Below: `STRATEGY.md` verbatim, `references/summary.md` content, blueprint chapter titles + one-line topic, and the project's stated goal (one paragraph from `references/challenge.lean.ref`).

## Question

Iter-172 strategy-critic `route172` issued 7 CHALLENGES; all were addressed in the same plan-phase by a STRATEGY.md restructure (12 phase rows + Routes prose + the iter-172 audit verdict on A.4). I want a fresh-context audit of the **post-restructure** STRATEGY.md.

Specifically:

- Is the 12-row `## Phases & estimations` table internally consistent (iter estimates vs LOC vs realized-per-iter)?
- Are the new per-sub-phase rows (A.1.a / A.1.b / A.1.c / A.2.a / A.2.b / A.2.c / A.3 / A.4 / RR.1 / RR.2 / RR.3 / RR.4) decomposed cleanly, or is something double-counted / under-estimated?
- Does the `## Routes` prose still make sense post-restructure?
- The new `## Open strategic questions` entry on A.4 ↔ RR.1 material sharing — is this question well-posed?
- The genus-0 row: iter-172 Lane A landed PRIMARY 1 axiom-clean (1 sorry helper closed; iso now axiom-clean). Is `Iters left ~4-7` still defensible, or should the post-PRIMARY-1 progress shift this?
- Anything else missing or wrong?

## STRATEGY.md verbatim

<!-- planner: full STRATEGY.md text inserted below; do not paraphrase -->

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese / Jacobian
object uniform over the $k$-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with **no** `C(k) \neq \emptyset` hypothesis. End-state:
zero inline `sorry`, kernel-only axioms.

The protected signature quantifies over arbitrary `C` with no $C(k) \neq \emptyset$
assumption. The witness OBJECT `J` is always real (constructed unconditionally);
only `isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. The spine is
**pointed vs. unpointed**, not genus-0 vs. positive. `genus C := \dim_k H^1(C,O_C)`
(arithmetic genus; protected — cannot be re-typed).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **Route A.1.a — `RelativeSpec` (qcoh-algebras → schemes)** (CRITICAL PATH; parallel-startable) | chapter `Picard_RelativeSpec.tex` PENDING (3rd writer attempt iter-172); file-skeleton lane opens immediately on landing | ~3–5 | ~200–400 · ~0/it | `RelativeSpec` functor; affine-base reduction (Stacks 01LO); base change (01LS) | once chapter lands, mechanical file-skeleton + body fill |
| **Route A.1.b — `LineBundle.Pullback` on `C ×_k T`** (CRITICAL PATH; gated on A.1.a) | blueprint chapter NOT YET WRITTEN | ~2–4 | ~200–400 · gated | line-bundle pullback by base change; sheafification (present) | small once A.1.a lands |
| **Route A.1.c — `RelPic functor` (relative Picard presheaf)** (CRITICAL PATH; gated on A.1.b) | blueprint chapter NOT YET WRITTEN | ~2–4 | ~300–500 · gated | ét-sheafification (present); presheaf functoriality | wires `Pic^♯` from A.1.a + A.1.b |
| **Route A.2.a — Flattening stratification of a coherent sheaf** (CRITICAL PATH; parallel-startable) | blueprint chapter NOT YET WRITTEN | ~5–8 | ~600–900 · ~0/it | Stacks 052H flattening (absent in Mathlib) | independently startable (does NOT gate on A.1) |
| **Route A.2.b — Quot scheme representability (Nitsure §5)** (CRITICAL PATH; gated on A.2.a + A.1.a) | blueprint chapter NOT YET WRITTEN | ~6–10 | ~800–1000 · gated | `QuotScheme` (absent); Yoneda-via-charts | the load-bearing FGA piece |
| **Route A.2.c — FGA `Pic_{C/k}` representability assembly** (CRITICAL PATH; gated on A.2.b + A.1.c) | blueprint chapter NOT YET WRITTEN | ~4–7 | ~600–800 · gated | wires Quot + RelPic to get representable Picard | small assembly once both parents land |
| **Route A.3 — `Pic⁰` identity component + degree map** (CRITICAL PATH; gated on A.2.c) | per-sub-phase decomposition in `Jacobian.tex`; identity-component construction + locally-constant pushforward | ~5–8 | ~600–900 · ~0/it | `GroupScheme.IdentityComponent` (absent); `LocallyConstantPushforward` (absent); Mathlib `Group/{Smooth,Abelian}.lean` anchors | gated on A.2.c |
| **Route A.4 — Albanese UP of `Pic⁰`** (CRITICAL PATH; gated on A.1.c + A.3 + the Thm 3.2 sub-build) | iter-172 audit RESOLVED to Outcome (b): bypass FAILS (Milne III §6 Prop 6.1 invokes Thm 3.2); A.4 inherits the Thm 3.2 + Lemma 3.3 sub-build | ~22–35 | ~2500+ · ~0/it | Thm 3.2 + Lemma 3.3 codim-1 + Weil-divisor API + Auslander–Buchsbaum (absent) | dominant Route A risk |
| **genus-0 rigidity** — `gmScalingP1` body + collapse-at-zero | body skeleton LANDED iter-171; 3 named scaffold sorries + 1 surjective helper | ~4–7 | ~150–220 · ~80/it | `Scheme.OpenCover.glueMorphisms*`; `pullbackSpecIso`; `Proj.fromOfGlobalSections`; `Away.adjoin_mk_prod_pow_eq_top` | re-estimated iter-172 per progress-critic OVER_BUDGET |
| **genus-0 RR.1 — Weil divisors on a smooth curve** (parallel-startable) | chapter landed iter-171 (445 LOC, 9 pins); file-skeleton lane iter-172 | ~3–6 | ~300–500 · ~0/it | divisors at scheme level; closed-point order; degree map (all absent — in-tree) | the lone parallel-startable RR entry |
| **genus-0 RR.2 — Riemann–Roch formula for genus 0** (gated on RR.1) | blueprint chapter NOT YET WRITTEN | ~3–5 | ~400–600 · gated | finite-rank cohomology + Euler-characteristic formula | the dimension-count engine |
| **genus-0 RR.3 — `O_C(P)` global sections (`dim = 2`)** (gated on RR.2) | blueprint chapter NOT YET WRITTEN | ~3–5 | ~400–600 · gated | invertible sheaf at a point; restriction sequence; H⁰ identification | extracts the non-constant function |
| **genus-0 RR.4 — rational curve ⟹ `≅ ℙ¹`** (gated on RR.3) | blueprint chapter NOT YET WRITTEN | ~3–5 | ~400–600 · gated | `Proj.fromOfGlobalSections`; degree-1 morphism is iso | finishes the bridge |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated on genus-0 rigidity + genus-0 RR bridge | 3–5 | 350–850 · gated | terminal cluster on `Spec k`; faithfully-flat descent of a morphism equality | descent direction unconfirmed |
| `nonempty_jacobianWitness` genus-stratified body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |
| **Refactor — `Genus0BaseObjects.lean` split** (HOUSEKEEPING) | gated on iter-172 Lane A sorry residual stabilising | 1 (iter-173) | ~880 redistributed | none — pure file-move | low; verified seams |
| **Refactor — `Cohomology/StructureSheafModuleK.lean` split** (HOUSEKEEPING) | scheduled hygiene iter | 1 (deferred) | ~877 redistributed | none — pure file-move | low; not gating any active lane |

## Routes

The positive-genus OBJECT is built by **Route A (Picard scheme via FGA)** — mandatory and essentially unavoidable. The genus-0 arm is a separate, lower-risk rigidity statement (object trivial); its base-case proof route is **Route C (Milne §I.3 rigidity completion)**, chosen because Milne §I.3 + §III.6 derive both the genus-0 base case AND Route A's Albanese UP cube-free, and a Mathlib-support survey found Route C far less blocked than the differential route.

(... continues with Route A + Route C prose + Open strategic questions + Mathlib gaps — see canonical STRATEGY.md ...)
```

## Project goal (from `references/challenge.lean.ref`)

The project formalizes Christian Merten's Jacobian challenge: nine protected
declarations including `AlgebraicGeometry.Jacobian` (the Jacobian object of a
smooth proper geometrically-irreducible curve `C/k`) and
`Jacobian.nonempty_jacobianWitness` (existence of an Albanese witness with **no**
`C(k) ≠ ∅` hypothesis).

## Blueprint chapter index (titles + one-line topic)

- `AbelJacobi.tex` — Abel–Jacobi morphism (genus-1 case wiring).
- `AbelianVarietyRigidity.tex` — Milne Rigidity Lemma chain + genus-0 base case via 𝔾_m-scaling (consolidated; covers `AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean`, `RigidityLemma.lean`).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — cotangent space at the identity of a group scheme (fallback-(a) asset).
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES; finiteness of H^0/H^1 on a curve.
- `Cohomology_SheafCompose.tex` — sheaf composition helpers.
- `Cohomology_StructureSheafAb.tex` — Ab-valued structure sheaf.
- `Cohomology_StructureSheafModuleK.tex` — ModuleCat-k structure sheaf + H^0/H^1 finiteness.
- `Differentials.tex` — Ω^1 differentials helpers.
- `Genus.tex` — genus = dim H^1(C, O_C).
- `Jacobian.tex` — the headline `Jacobian` + `JacobianWitness` + Route A per-sub-phase budget (A.1.a/b/c, A.2.a/b/c, A.3, A.4).
- `Picard_RelativeSpec.tex` — A.1.a (`RelativeSpec` functor; qcoh-algebras → schemes; iter-172 landed).
- `RiemannRoch_WeilDivisor.tex` — RR.1 (Weil divisors on a smooth curve; iter-171 landed).
- `Rigidity.tex` — `Scheme.Over.ext_of_eqOnOpen` (dominant-source + separated-target).
- `RigidityKbar.tex` — fallback-(a) `rigidity_over_kbar` artifact (`[CharZero]`; off critical path; demoted iter-163).

## References summary (excerpt — the planner-injected references/summary.md is authoritative)

| File | Description |
|---|---|
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian. |
| `abelian-varieties.pdf` (Milne, 2008) | Rigidity Thm 1.1 (I.1); Thm 3.2 + Prop 3.10; theorem of the cube §I.5; Albanese UP of Pic⁰ III.6. |
| `kleiman-picard.pdf` (Kleiman, FGA Explained) | Route A source: §4 existence, §5 Pic⁰, §6 Pic^τ. |
| `nitsure-hilbert-quot.pdf` (Nitsure, FGA Explained) | Quot/Hilbert construction engine. |
| `mumford-abelian-varieties.pdf` (Mumford) | Independent reference for rigidity / cube. |
| `stacks-*.{md,tex}` | Stacks-Project chapters: 9 Fields, 10 Algebra, 27 Constructions of Schemes, 30 Cohomology, 33 Varieties (incl. tag 052H flattening). |
| `analogies/*.md` | Internal API-alignment / cross-domain consults (route-support, thm32-extend, gmscaling-deep, tensoraway-instance, rrbridge-survey, cotangent-vanishing-pile, etc.). |

## Constraints on your output

- Per the strict-context-discipline rule, you must NOT read iter sidecars, task_pending.md, PROGRESS.md, recent prover output, or any per-iter narrative beyond what is above. If something below has crept in despite my discipline, ignore it.
- Per-route verdict: `SOUND` / `CHALLENGE` / `REJECT`. For each CHALLENGE / REJECT, propose the minimal STRATEGY.md edit that addresses it.
