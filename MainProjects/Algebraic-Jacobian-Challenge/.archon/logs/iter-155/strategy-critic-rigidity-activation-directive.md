# Strategy Critic Directive

## Slug
rigidity-activation

## Project goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations, headlined by `AlgebraicGeometry.Jacobian` and
`AlgebraicGeometry.Jacobian.nonempty_jacobianWitness` — the existence of an
Albanese/Jacobian object uniform over the k-rational pointing of a smooth proper
geometrically irreducible curve `C/k`, with **no** `C(k) ≠ ∅` hypothesis on the
protected signature. The witness object `J` is always constructed; only the
`isAlbaneseFor` universal-property field is quantified over pointings `P`.
End-state: zero inline `sorry`, kernel-only axioms.

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

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| Chart-algebra ring/chart envelope (over `[IsAlgClosed]`) | **DONE** — KDM closed iter-154 (axiom-clean); `constants`, `df_zero_factors`, thin `ext_of_diff_zero` all closed | 0 | 0 · realized | — | — (row retained one iter for context; drop next edit) |
| **`ext_of_diff_zero` β-chain refinement** (scheme-level `df = dg` ⟹ `f = g`) | ACTIVE — unblocked by KDM; blueprint Steps 1–3 written | 1–2 | ≈100–150 · new | `KaehlerDifferential.D_sub`/`Derivation.map_sub` [verified]; `GrpObj.mul_inv_eq_iff`/`lift_comp_inv_*` [expected]; project `ext_of_eqOnOpen` [verified] | Step 2 chart-by-chart sheaf-assembly globalisation is hand-waved in blueprint ("chart-uniform existence automatic") — reviewer to confirm prover-ready depth |
| `rigidity_over_kbar` full body (over `[IsAlgClosed kbar]`) | ACTIVE (unblocked) — but body NOT yet prover-ready | 2–4 | 150–400 · gated-on-blueprint | image-of-proper-map irreducible-closed; scheme dimension; **`df = 0` production for `f : C → A`** | TWO gaps beyond closed pieces: (a) establishing `df = 0` needs `Ω_{A/k}` cotangent-triviality (DESCOPED piece (i)) + genus-0 vanishing — UNRESOLVED how the chart-algebra route supplies it; (b) point-agreement→open-agreement bootstrap. Blueprint-writer needed before prover |
| `genusZeroWitness` body + terminal cluster on `Spec k` + **`k̄→k` descent** | gated | 3–5 | 350–850 · gated | `GrpObj`/`SmoothOfRelativeDimension 0`/`IsProper`/`GeometricallyIrreducible` on `Spec k`; **faithfully-flat descent of morphism equality along `Spec k̄ → Spec k`** (gap to assess) | terminal-object cluster; the descent obligation (right cancellation direction unconfirmed) absorbs the over-k cost displaced from `constants` |
| Genus-stratified body of `nonempty_jacobianWitness` | gated | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once arms close |
| `positiveGenusWitness` body via Route A — Picard scheme via FGA | off-critical-path | 40–70 | ~5100 · gated | Hilbert/Quot representability (irreducible bulk); identity-component subgroup scheme; fppf/étale topologies; flattening; coherent-of-finite-type | largest pure-Mathlib-build sub-project; existence engine cannot be trimmed |

## Routes

The project has two committed routes plus one carry-over alternative
the planner re-evaluates on a rolling trigger.

### Route C (M2 critical path) — chart-algebra piece (ii), over `[IsAlgClosed kbar]`

Sub-pieces in `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`, informal
content in `RigidityKbar.tex` § "Chart-algebra piece (ii)". The
ring/chart-level envelope is now CLOSED (KDM + constants + df_zero_factors).
The remaining Route C content is the SCHEME-LEVEL rigidity assembly:
the `ext_of_diff_zero` β-chain refinement and the `rigidity_over_kbar` body.

**`[IsAlgClosed kbar]` commitment.** `rigidity_over_kbar` is the over-`k̄`
statement and is not protected, so it carries `[IsAlgClosed kbar]`. The
chart-algebra chain inherits the algebraically-closed base. KDM's bare `B`-only
form is FALSE (counterexamples `B = k×k`, `ℚ(√2)/ℚ`); the alg-closed + domain
hypotheses make it TRUE. KDM CLOSED iter-154 via the single-element /
perfect-field / `H1Cotangent` route. `constants_integral_over_base_field`
CLOSED via the `[IsAlgClosed k]` collapse; the (S3.*) separability/inseparability
decomposition and the flat-base-change-of-Γ Mathlib gap are descoped off-path
(`ChartAlgebraS3.lean`, orphaned).

The named theorem Serre duality is NOT invoked. **Cost displaced downstream:**
proving rigidity only over `k̄` means the genus-0 witness over arbitrary `k`
must descend the constancy conclusion along `Spec k̄ → Spec k` — an open
obligation to assess against Mathlib's scheme-descent API
(faithfully-flat-descent of an equality of base-changed maps, NOT the
right-cancellation `Flat.epi_of_flat_of_surjective` alone).

### Route A (M3 off-critical-path) — Picard scheme via FGA

Hilbert / Quot scheme representability + identity-component subgroup scheme.
Decomposition A.1–A.4 in `Jacobian.tex` § "Route A". Sources in-tree:
`references/kleiman-picard.pdf`, `references/nitsure-hilbert-quot.pdf`. Net
~5100 LOC, irreducible Quot/Hilbert existence engine. Off-critical-path.

**Pointed-vs-unpointed spine.** `JacobianWitness C` bundles a REAL object `J`
(constructed unconditionally) + `isAlbaneseFor : ∀ P, IsAlbanese … J`. Genus-0's
`J` is the trivial dim-0 abelian variety `Spec k` (no Picard scheme); positive-
genus's `J` is the real `Pic⁰` via Route A. Vacuity touches only the `∀ P` field
for unpointed `C`. Route C's load-bearing content is the pointed-ℙ¹ rigidity.

## Open strategic questions

- **(NEW, load-bearing) How does `rigidity_over_kbar` establish `df = 0` for
  `f : C → A`?** The closed chart-algebra pieces give "`df = 0` ⟹ `f` constant"
  (piece (ii)), but producing `df = 0` classically needs `Ω_{A/k}` cotangent-
  triviality (the DESCOPED piece (i)) plus genus-0 vanishing. The chart-algebra
  pivot descoped piece (i); the rigidity body's df=0 input is therefore
  unresolved. Either (1) re-introduce a minimal form of piece (i) (group-scheme
  `Ω` triviality), or (2) find a chart-algebra route to `df = 0` directly.
- Should `Cotangent/ChartAlgebra.lean` get its own blueprint chapter rather than
  living as a subsection of `RigidityKbar.tex`?
- When to schedule M3 Route A scaffolding: parallel with M2 closure vs after.
- Char-0 first ordering of the KDM bridge; char-p Frobenius patch not scaffolded.
- `ChartAlgebraS3.lean` (4 off-path sorries) deletion: drops 7→3.

## Mathlib gaps & new material

**Gaps to fill:**
- `mem_range_algebraMap_of_D_eq_zero` (KDM) — CLOSED iter-154.
- **faithfully-flat descent of morphism equality** along `Spec k̄ → Spec k` —
  for `genusZeroWitness`; injectivity-of-restriction, NOT right-cancellation.
- `Scheme.Over.ext_of_diff_zero` substantive β-refinement (carry `df = dg`).
- (Route A) Hilbert/Quot representability; identity-component subgroup scheme;
  fppf/étale sheafification; flattening; coherent-of-finite-type (~5100 LOC).
- (deferred named) Serre duality on a smooth proper curve (3000–8000 LOC; NOT
  invoked — `H^0(C, Ω^⊕n) = 0` reached via chart-Čech MV).
- (optional M4) scheme-level converse of `smooth_locally_free_omega`.

**Caveat:** the bare local-freeness-of-Ω ⟹ smooth implication is FALSE; the true
converse needs `Subsingleton (Algebra.H1Cotangent A B)`.

**New project material:** `Cotangent/GrpObj.lean` (`cotangentSpaceAtIdentity`
trio); `Cotangent/ChartAlgebra.lean` (chart-algebra envelope); `Rigidity.lean`
`ext_of_eqOnOpen`.

**Soundness rules:** no new axioms (kernel-only); a `sorry` must be the body of a
top-level named declaration (no buried sorries).

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — formal statement of the missing defs/theorems for the Jacobian of an algebraic curve; authoritative signatures. |
| `stacks-varieties.md` | Stacks ch.33 "Varieties" — smooth-over-fields ⇒ geom regular/normal/reduced; `H^0(X,𝒪)` lemma. |
| `stacks-fields.md` | Stacks ch.9 "Fields" — purely inseparable; separable-then-inseparable factorisation. |
| `stacks-algebra.md` | Stacks ch.10 "Commutative Algebra" — standard smooth ⇒ `Ω_{S/R}` free. |
| `stacks-coherent.md` | Stacks ch.30 — flat base change of `R^i f_*`. |
| `kleiman-picard.md` | Kleiman, "The Picard scheme" (FGA Explained) — Route A. |
| `nitsure-hilbert-quot.md` | Nitsure, "Construction of Hilbert and Quot Schemes" — Quot/Hilbert engine behind Route A. |

## Blueprint summary

- `Cohomology_SheafCompose.tex` — sheaf composition / HasSheafCompose instances.
- `Cohomology_StructureSheafAb.tex` — abelian-group structure sheaf, sheafify/Ext.
- `Cohomology_StructureSheafModuleK.tex` — ModuleCat k structure sheaf, HModule cohomology, Čech.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris LES, affine Čech-acyclic covers, finiteness.
- `Differentials.tex` — relative cotangent, smooth ⇒ locally free Ω (forward Jacobian criterion).
- `Genus.tex` — genus = finrank H^1(C, 𝒪_C).
- `Jacobian.tex` — JacobianWitness bundle, Albanese property, genus-0/positive split, Route A.
- `Rigidity.tex` — `ext_of_eqOnOpen` (dominant-source/separated-target morphism rigidity).
- `RigidityKbar.tex` — rigidity over k̄ (`rigidity_over_kbar`); consolidated chart-algebra
  piece (ii) envelope incl. KDM, `constants_integral`, `df_zero_factors`, `ext_of_diff_zero`;
  the shared cotangent-vanishing pile decomposition (i)–(iv).
- `AlgebraicJacobian_Cotangent_GrpObj.tex` — group-scheme cotangent space at identity + rank.
- `AlgebraicJacobian_Cotangent_ChartAlgebraS3.tex` — DESCOPED off-path separability/inseparability scaffolds.
- `AbelJacobi.tex` — Jacobian.ofCurve routing, transit of nonempty_jacobianWitness.

## Prior critique status

- iter-152: format DRIFTED (per-iter narrative in STRATEGY.md) — live (not fully cleaned)
- iter-152: `[IsAlgClosed]` pivot soundness — addressed (KDM + constants now closed, validating it)
- iter-152: k̄→k descent obligation is a real gap, not a two-liner — live (still unassessed)
