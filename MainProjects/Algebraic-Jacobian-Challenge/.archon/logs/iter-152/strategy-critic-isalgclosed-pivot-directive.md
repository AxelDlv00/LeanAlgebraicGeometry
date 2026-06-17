# Strategy Critic Directive

## Slug
isalgclosed-pivot

## Project goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese/Jacobian
object uniform over the k-rational pointing of a smooth proper geometrically
irreducible curve C/k, with NO `C(k) ≠ ∅` hypothesis on the protected
signature. End-state: zero inline `sorry`, kernel-only axioms. Protected
declarations (signatures frozen): `AlgebraicGeometry.genus`,
`AlgebraicGeometry.Jacobian` (+ its `instGrpObj`, `smoothOfRelativeDimension_genus`,
`instIsProper`, `instGeometricallyIrreducible`), `Jacobian.ofCurve`,
`Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp`. NOTE:
`rigidity_over_kbar`, `constants_integral_over_base_field`, the KDM lemma
`mem_range_algebraMap_of_D_eq_zero`, and the (S3.*) lemmas are NOT protected.

## Focus question for this audit

This iter executes a route pivot: after a prover lane PROVED the lemma
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` is mathematically
FALSE as a `B`-only algebra lemma (it lost the geometric "k algebraically
closed in B" content; counterexamples B=k×k and ℚ(√2)/ℚ), the planner
committed to adding `[IsAlgClosed kbar]` to `rigidity_over_kbar` (the over-k̄
rigidity statement). Please scrutinise specifically:
(1) Is adding `[IsAlgClosed kbar]` goal-aligned, given the protected
`Jacobian`/`nonempty_jacobianWitness` are over ARBITRARY k? The planner's
claim is that the genus-0 witness over arbitrary k base-changes to k̄, applies
rigidity there, and DESCENDS along Spec k̄ → Spec k (faithfully-flat descent of
morphism equality). Is this descent step sound and is it honestly costed?
(2) Does the alg-closed collapse of `constants_integral_over_base_field` via
`IsAlgClosed.algebraMap_bijective_of_isIntegral` genuinely descope the (S3.pi.*)
flat-base-change gap, or is the gap merely relocated?
(3) Is there sunk-cost reasoning in keeping the chart-algebra/KDM route at all
vs. a cleaner over-k̄ rigidity argument?

## Strategy under review

# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — the existence of an Albanese / Jacobian
object uniform over the $k$-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with **no** `C(k) ≠ ∅` hypothesis on the protected
signature. End-state: zero inline `sorry`, kernel-only axioms.

The protected signature quantifies over arbitrary `C` with no $C(k) \neq \emptyset$
assumption. The witness OBJECT `J` is always real (constructed unconditionally);
only `isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. The spine is
**pointed vs. unpointed**, not genus-0 vs. positive: a pointed genus-0 curve is
`≅ ℙ¹_k` and its universal property is the non-vacuous Route C rigidity; an
unpointed curve (e.g. a Brauer–Severi conic over `ℚ` — so `C ≅ ℙ¹_k` may NOT be
assumed) satisfies `isAlbaneseFor` vacuously. See Routes for the full split.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| Chart-algebra envelope (post-`[IsAlgClosed]` pivot) | KDM signature corrected; `constants` collapses; (S3.*) descoped | 3–6 | 150–350 (remaining) | `IsAlgClosed.algebraMap_bijective_of_isIntegral` [verified]; `KaehlerDifferential.D`; `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified]; `MvPolynomial.mkDerivation`/`pderiv` [verified] | KDM corrected lemma (`[IsAlgClosed k]`+`[IsDomain B]`) now TRUE but transfer step still substantive; char-p deferred |
| `rigidity_over_kbar` body closure (over `[IsAlgClosed kbar]`) | gated on chart-algebra | 2 | 50–150 | `Scheme.Over.ext_of_eqOnOpen` | depends on chart-algebra closure |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 | `GrpObj`/`SmoothOfRelativeDimension 0`/`IsProper`/`GeometricallyIrreducible` on `Spec k`; **faithfully-flat descent of morphism equality along `Spec k̄ → Spec k`** (new gap) | terminal-object cluster; the new descent obligation absorbs the over-k cost displaced from `constants` |
| Genus-stratified body of `nonempty_jacobianWitness` | gated | 1 | <50 | `by_cases h : genus C = 0` | trivial once arms close |
| `positiveGenusWitness` body via Route A — Picard scheme via FGA | off-critical-path | 40–70 | ~5100 midpoint | Hilbert/Quot representability (irreducible bulk); identity-component subgroup scheme; fppf/étale topologies; flattening; coherent-of-finite-type | largest pure-Mathlib-build sub-project; existence engine cannot be trimmed |

## Routes

The project has two committed routes plus one carry-over alternative
the planner re-evaluates on a rolling trigger.

### Route C (M2 critical path) — chart-algebra piece (ii), over `[IsAlgClosed kbar]`

Sub-pieces in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`, informal
content in `RigidityKbar.tex` § "Chart-algebra piece (ii)". Closed
sub-pieces are summarised in the iter sidecar; STRATEGY.md tracks only
remaining work.

**`[IsAlgClosed kbar]` pivot (committed; resolves the standing
user-input fork).** The bright-line STUCK trigger fired: the iter-151
prover lane proved `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
is **mathematically FALSE** as a `B`-only algebra lemma (CE1 `B = k×k`,
CE2 `ℚ(√2)/ℚ` — both satisfy every hypothesis, both break the conclusion;
the lost data is "`k` algebraically closed in `B`"). The forced
corrective is the architectural signature change, coupled to the
`[IsAlgClosed kbar]` decision. **Decision: YES** — `rigidity_over_kbar`
is literally the over-`k̄` statement (its docstring already says `k̄`
algebraically closed) and is not protected; adding `[IsAlgClosed kbar]`
matches intent and resolves the fork. Effects:

- (KDM ring-side) `mem_range_algebraMap_of_D_eq_zero` — signature
  corrected to `[Field k] [IsAlgClosed k] [CharZero k]` + `[IsDomain B]`
  + finite-type + standard-smooth. Now TRUE (CE1 killed by `[IsDomain B]`,
  CE2 killed by `[IsAlgClosed k]`). Closure reuses the closed (C.a) FREE-CASE
  `_mvPoly_*` helpers + (C.b) lift + (C.c) `map_D` functoriality, plus a
  "`k` alg-closed in `B` (geometrically integral domain), char-0 ⟹ the
  algebraic closure of `k` in `Frac B` is `k` ⟹ `ker D ∩ B = k`" step
  (substantive but no longer false). Char-p (p1) parked.
- (constants substep 3) `constants_integral_over_base_field` —
  **collapses** under `[IsAlgClosed k]`: `Γ(X, O_X)` is a finite field
  extension of `k` (from the proper + integral chain already in the body),
  and `IsAlgClosed.algebraMap_bijective_of_isIntegral` [verified,
  `Mathlib.FieldTheory.IsAlgClosed.Basic`] makes `algebraMap k Γ`
  bijective ⟹ surjective in ~15 LOC. The (S3.sep.1/2)+(S3.pi.1/2)
  decomposition and the load-bearing flat-base-change-of-Γ Mathlib gap
  are **descoped** (no longer on the critical path).

Chart-algebra closes the `df = 0` derivation chain: per-chart
Kähler-derivation kernel extraction on standard-smooth charts (uses
`Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified]) over the
algebraically-closed base. The named theorem Serre duality is NOT invoked.

**Cost displaced downstream.** Proving rigidity only over `k̄` means the
genus-0 witness over an arbitrary `k` must descend the constancy
conclusion along `Spec k̄ → Spec k` (faithfully-flat descent of morphism
equality — new Mathlib gap, localised in `genusZeroWitness`, already
gated). This trades the deep proper-cohomology base-change gap for a
shallower fppf-descent-of-morphisms gap.

**Bright-line (updated).** The STUCK trigger has fired and the pivot is
the executed corrective. Route C still tolerates **no sorry-count-inflating
re-decomposition** of the KDM lemma: the corrected-signature lemma is
either closed via the (C.a)–(C.c) scaffold + the alg-closed-constants
step, or — if it again resists — the next corrective is `mathlib-analogist`
on the "constants of a derivation on a geometrically-integral algebra"
shape, NOT another helper layer.

### Route A (M3 off-critical-path) — Picard scheme via FGA

Hilbert / Quot scheme representability + identity-component subgroup
scheme construction. Decomposition A.1–A.4 in `Jacobian.tex` §
"Route A — Picard scheme". Literature: the genuine source files now
in-tree — `references/kleiman-picard.pdf` ("The Picard scheme") and
`references/nitsure-hilbert-quot.pdf` ("Construction of Hilbert and
Quot Schemes").

**Kleiman re-scope finding** (from `references/kleiman-picard.pdf`).
Dependency chain: Nitsure Quot/Hilbert (A1) → Kleiman `th:main`
existence (§4) → `prp:P0`/`lem:agps` formal identity-component
structure (§5, A2) → `ex:jac` curve Jacobian. §5 is "formal, without
the finiteness theorems", so A2/A3 shrink; but `ex:jac` routes
existence through `th:main` → the full Quot/Hilbert engine, which is
**irreducible**. Net midpoint ~6070 → **~5100 LOC** (A1 ~3775 fixed;
A2 ~1320→~800; A3 ~975→~500 via curve `Pic⁰=Pic^τ`). Picked over Route
B (Symⁿ+Stein: $S_n$-quotient infra no closer to Mathlib, still needs
identity-component). Priority unchanged: off-critical-path.

**Pointed-vs-unpointed spine (not genus-0-vs-positive).** `JacobianWitness C`
bundles a REAL object `J` (constructed unconditionally) plus
`isAlbaneseFor : ∀ P, IsAlbanese … J`. The object obligation is
unconditional on both arms: genus-0's `J` is the trivial dim-0
abelian variety `Spec k` (no Picard scheme), and positive-genus's `J`
is the real `Pic⁰` via Route A — required even when `C(k) = ∅`, since
`J` must be a dim-`g` abelian variety regardless. Vacuity touches ONLY
the `∀ P` universal-property field for unpointed `C`. Route C's
load-bearing content is the **pointed-ℙ¹ rigidity** (the genus-0
universal property: a map `C → A` killing `P` is constant, factoring
uniquely through `Spec k`) — NOT vacuity. So genus-0 needs no Picard
scheme but DOES need Route C; Route A is needed for the positive-genus
object unconditionally.

### Alternative — over-$\bar k$ + Galois descent for M2.a

Base-change to $\bar k$ (genus-0 forces $C_{\bar k} \cong \mathbb{P}^1_{\bar k}$),
rigidity there → group scheme, descend to $k$ via
fpqc-descent-of-morphisms (Mathlib gap). DECORATIVE — no concrete
descent-infra LOC bid yet, so not in the decision loop.

### Hybrid pivot (analogist-recommended) — CharZero + MvPolynomial

Three HYBRID analogues (from the analogist consult); status:
- **(A) Consumer reformulation over $\bar k$** (`[IsAlgClosed kbar]`) —
  **COMMITTED** (was user-gated; decided YES at iter-152 after the
  KDM-false STUCK trigger). Collapses `constants_integral_over_base_field`
  via `IsAlgClosed.algebraMap_bijective_of_isIntegral` and descopes the
  (S3.pi.*) flat-base-change gap. See Route C above.
- **(C) KDM (BR.5)** via `MvPolynomial.mkDerivation` + `pderiv` +
  standard-smooth surjection transfer — the (C.a)–(C.c) scaffold is
  closed and reusable for the corrected `[IsAlgClosed]`+`[IsDomain B]`
  signature; the residual is the alg-closed-constants transfer step.
- **(B) CharZero collapse of (S3.sep.*)** — moot under part (A) (the
  whole (S3.*) chain is descoped); the general-over-`k` (S3.*) lemmas
  remain valid off-path scaffolds.

The direct H1Cotangent-vanishing pivot is DISCARDED (André-Quillen H¹
is independent content from `Γ ≅ k`; name collision only). Full
analogue list: `analogies/h1cotangent-vanishing-iter150.md`.

## Open strategic questions

- Should `Cotangent/ChartAlgebra.lean` get its own blueprint chapter
  rather than living as a subsection of `RigidityKbar.tex`?
- When to schedule M3 Route A scaffolding: parallel with M2 closure
  vs strictly after M2 closes.
- **User-input question (DECIDED iter-152, YES)**: the coupled fork is
  resolved — `[IsAlgClosed kbar]` is added to `rigidity_over_kbar`
  (reverses the iter-127 over-k commitment for the rigidity sub-step),
  which collapses `constants_integral_over_base_field` and **descopes**
  the (S3.pi.1) flat-base-change gap entirely (no build/axiomatize
  needed). Cheapest reversal signal: if the `k̄→k` descent obligation in
  `genusZeroWitness` turns out to need MORE Mathlib infrastructure than
  the (S3.pi.1) gap it replaced, revisit. Surfaced to the user as an FYI
  (override via `USER_HINTS.md`).
- Char-0 first ordering of the KDM bridge: char-p needs a project-side
  Frobenius-iteration patch not yet scaffolded.

## Mathlib gaps & new material

**Gaps to fill (in-tree project material, project-namespaced until
upstream-extracted):**

- `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  — KDM ring-side core, corrected signature (`[IsAlgClosed k]`+`[CharZero k]`
  +`[IsDomain B]`+finite-type+standard-smooth). The (C.a)–(C.c) scaffold
  is reusable; residual = the alg-closed-constants transfer step. Char-p
  alternative (p1) parked.
- `AlgebraicGeometry.constants_integral_over_base_field` — under
  `[IsAlgClosed k]` collapses to ~15 LOC via
  `IsAlgClosed.algebraMap_bijective_of_isIntegral` [verified]. NO Mathlib
  gap remains. The (S3.*) decomposition is **descoped** from the critical
  path; the four general-over-`k` (S3.sep.1/2)+(S3.pi.1/2) lemmas in
  `ChartAlgebraS3.lean` (Stacks Tags 056T/0BUG/02KH/09HD) survive as valid
  off-path scaffolds / future Mathlib-PR fodder, not blocking.
- **(NEW) faithfully-flat descent of morphism equality** along
  `Spec k̄ → Spec k`: needed in `genusZeroWitness` to descend the over-`k̄`
  rigidity conclusion to over-`k`. Likely a thin wrapper over fpqc/faithfully-
  flat surjectivity-of-`Hom`-restriction; assess against Mathlib's scheme
  descent API when `genusZeroWitness` activates.
- `KaehlerDifferential.constants_in_chart_of_proper_curve` (chart-of-
  proper-curve hypothesis extractor) + `Scheme.Over.ext_of_diff_zero`
  (carry `df = dg` via `ext_of_eqOnOpen`) — small chart-algebra helpers.
- (M3 Route A): Hilbert/Quot representability; identity-component
  subgroup scheme; fppf/étale sheafification; Picard pre-functor;
  flattening stratification; coherent-of-finite-type. LOC ~5100 (see
  the Route A subsection for the Kleiman re-scope + literature).
- (deferred named) Serre duality on a smooth proper curve
  (3000–8000 LOC). NOT invoked; cohomological content
  $H^0(C, \Omega_C^{\oplus n}) = 0$ is reached via chart-Čech MV
  (above), not via the named theorem.
- (optional M4) Scheme-level converse of `smooth_locally_free_omega`
  (needs `Subsingleton (Algebra.H1Cotangent A B)` [verified]).
  Deferred until downstream consumer demand.

**Caveat: false-converse pitfall.** The bare local-freeness-of-$\Omega$
implication is **mathematically false** (`Spec k → Spec k[t]` via
`t ↦ 0`: lfp with $\Omega = 0$ but not flat, so not smooth). The true
converse needs `Subsingleton (Algebra.H1Cotangent A B)`;
`Differentials.tex` discloses this — we do not state the false iff.

**New project material introduced:**

- `Cotangent/GrpObj.lean` — `cotangentSpaceAtIdentity` trio
  (definition + structural acceptance lemma + rank lemma; piece (i.a)
  of the original bundled-route).
- `Cotangent/ChartAlgebra.lean` — 5-block chart-algebra envelope.
- `Rigidity.lean` `ext_of_eqOnOpen` — scheme-level dominant-source /
  separated-target rigidity packaging; consumed by both Route C
  scheme-lift and the uniqueness half of the Albanese property.

**Soundness rules (operational, project-wide):**

- **No new axioms.** Every closed declaration `lean_verify`s to
  kernel-only axioms (`propext, Classical.choice, Quot.sound`).
- **Sorry-must-be-named-declaration.** A `sorry` must be the body of
  a top-level named declaration. It must NOT be embedded inside a
  `letI` / `have` / anonymous-`fun` body inside a different
  declaration. Without this discipline, a buried `sorry` propagates
  a sorry-tainted value through `simp` consumers without surfacing a
  `declaration uses sorry` warning at the wrapping declaration.

## References index

# References

<!-- archon:references-summary -->

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
| [`stacks-varieties.md`](./stacks-varieties.md) → `stacks-varieties.tex` | Stacks ch.33 "Varieties" — tags **035U** (§geom-reduced), **04QM**/**056T** (smooth over fields ⇒ geom regular/normal/reduced), **0BUG** (8-part `H^0(X,𝒪)` lemma, part (4) geom-reduced⇒separable). Backs (S3.sep.*). |
| [`stacks-fields.md`](./stacks-fields.md) → `stacks-fields.tex` | Stacks ch.9 "Fields" — tags **09HD** (§purely inseparable), **030K** (separable-then-inseparable factorisation). Backs (S3.pi.2). |
| [`stacks-algebra.md`](./stacks-algebra.md) → `stacks-algebra.tex` | Stacks ch.10 "Commutative Algebra" — tag **00T7** (standard smooth ⇒ `Ω_{S/R}` free on `dx_{c+1},…,dx_n`), L37259. Backs (BR.2)–(BR.5). Large file: jump to line. |
| [`stacks-coherent.md`](./stacks-coherent.md) → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes" — tag **02KH** (flat base change of `R^i f_*`; part (2) `H^0`-with-base-change). Backs (S3.pi.1). |
| [`kleiman-picard.md`](./kleiman-picard.md) → `kleiman-picard.pdf` / `-src/*.tex` | Kleiman, "The Picard scheme" (FGA Explained / arXiv:math/0504020). Route A source. **Deep map**: §4 existence, §5 `Pic⁰` (Jacobian, pp.36–51), §6 `Pic^τ` finiteness. |
| [`nitsure-hilbert-quot.md`](./nitsure-hilbert-quot.md) → `nitsure-hilbert-quot.pdf` / `-src/*.tex` | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590). Quot/Hilbert construction engine behind Route A. |

## Blueprint summary

- AbelJacobi.tex — The Abel–Jacobi map.
- AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex — Chart-algebra (S3) sub-claims (piece (ii) Lane 1).
- AlgebraicJacobian_Cotangent_GrpObj.tex — Cotangent space at the identity (piece (i)).
- Cohomology_MayerVietoris.tex — Mayer–Vietoris LES for sheaf cohomology with k-module coefficients.
- Cohomology_SheafCompose.tex — Sheaf condition along the structure-sheaf forget composite.
- Cohomology_StructureSheafAb.tex — Structure sheaf as a sheaf of abelian groups; sheafification, Ext.
- Cohomology_StructureSheafModuleK.tex — Sheaves of k-modules: sheafification, Ext, structure sheaf.
- Differentials.tex — The relative cotangent presheaf.
- Genus.tex — Genus of a smooth proper curve.
- Jacobian.tex — The Jacobian as an abelian variety (Route A — Picard scheme via FGA).
- Rigidity.tex — Rigidity for morphisms of schemes (scheme-level; Mumford §4).
- RigidityKbar.tex — Rigidity over a base field: morphisms from a genus-0 curve to a group scheme are constant (hosts the chart-algebra piece (ii) decomposition).

## Prior critique status

- iter-151: spine framing (pointed-vs-unpointed) — addressed
- iter-151: format size (~252 lines) — addressed (now ~232 lines / ~14 KB)
- iter-151: Route A re-scope honesty (A1 a floor) — addressed
