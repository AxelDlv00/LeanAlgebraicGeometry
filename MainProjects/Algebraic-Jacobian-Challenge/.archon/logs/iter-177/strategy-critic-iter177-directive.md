# strategy-critic — iter-177 directive

You are dispatched at the start of iter-177 plan-phase, AFTER iter-176
prover phase and BEFORE iter-177 prover dispatch.

**Strict context discipline applies** (your descriptor enforces this).
You receive only:

1. The current `STRATEGY.md` (verbatim, see below).
2. `references/summary.md` content.
3. A blueprint summary (chapter titles + one-line topic from
   `blueprint/src/chapters/*.tex`).
4. The project's stated goal.

You do NOT receive: iter sidecars, PROGRESS.md, task_pending.md,
task_done.md, prover task_results, review reports.

## Project goal

Formalize Christian Merten's Jacobian challenge
(`references/challenge.lean`): nine protected declarations headlined by
`AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` —
existence of an Albanese/Jacobian object uniform over the `k`-rational
pointing of a smooth proper geometrically irreducible curve `C / k`,
with **no** `C(k) ≠ ∅` hypothesis. Char-general: protected signatures
take `[Field k]` only (no `CharZero`).

## STRATEGY.md (verbatim)

```
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean`):
nine protected declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — existence of an Albanese / Jacobian
object uniform over the `k`-rational pointing of a smooth proper
geometrically irreducible curve `C / k`, with **no** `C(k) ≠ ∅` hypothesis.
End-state: zero inline `sorry`, kernel-only axioms. **Char-general:** the
protected signatures take `[Field k]` only — NO `CharZero`. Any char-0
sub-case route is therefore PARTIAL only.

The witness OBJECT `J` is always real (constructed unconditionally); only
`isAlbaneseFor` is universally quantified over `P : 𝟙_ _ ⟶ C`. Spine:
**pointed vs. unpointed**. `genus C := \dim_k H^1(C, O_C)` (arithmetic
genus; protected — cannot be re-typed).

## Phases & estimations

LOC bands re-estimated to honor the realized ~50 LOC/it on A.1.a (the
only validated body-fill rate). Route A sub-phases at the same rate
push the positive-genus total to ~180–320 iters; iter bands widened
accordingly. Velocity figures in `LOC (remaining · realized/it)`.

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **A.1.a — `RelativeSpec`** | chapter + file-skeleton landed; `QcohAlgebra` carrier axiom-clean | ~3–5 | ~200–400 · ~50/it | qcoh-algebras → schemes; affine-base reduction | mechanical once skeleton lands |
| **A.1.b — `LineBundle.Pullback`** | chapter + file-skeleton landed | ~2–4 | ~200–400 · ~50/it | line-bundle pullback; sheafification | small once A.1.a body lands |
| **A.1.c — `RelPic functor`** | chapter landed; file-skeleton pending | ~4–8 | ~300–500 · gated | ét-sheafification; presheaf functoriality | wires Pic^♯ from A.1.a + A.1.b |
| **A.2.a.i — Generic flatness** | chapter landed (consolidated A.2.a); sub-phase pending | ~10–16 | ~500–800 · gated | Stacks 052H pieces; generic flatness | unowned Mathlib-gap: see Open Qs |
| **A.2.a.ii — Noetherian induction over coherent strata** | chapter landed; sub-phase pending | ~16–26 | ~800–1300 · gated | noetherian induction; stratum definition | iterates on A.2.a.i |
| **A.2.a.iii — Stratum-glueing & functoriality** | chapter landed; sub-phase pending | ~14–28 | ~700–1400 · gated | gluing along finite stratification | assembly of A.2.a.i + ii |
| **A.2.b.i — Grassmannian scheme** | chapter landed; sub-phase pending | ~12–22 | ~600–1100 · gated | Plücker; projective embedding; functor of points | absent from Mathlib |
| **A.2.b.ii — Flat-locus open subscheme** | chapter landed; sub-phase pending | ~16–30 | ~800–1500 · gated | flat-locus openness; descent of flatness | builds on A.1.a + A.2.a.i |
| **A.2.b.iii — Quot representability assembly** | chapter landed; sub-phase pending | ~24–48 | ~1200–2400 · gated | Quot via Hilbert; sub-scheme glueing | bundles A.2.b.i + ii + A.2.a |
| **A.2.c — FGA `Pic_{C/k}` assembly** | chapter landed | ~12–16 | ~600–800 · gated | wires Quot + RelPic | small assembly |
| **A.3 — `Pic⁰` identity component + degree** | per-sub-phase in `Jacobian.tex`; unowned identity-component substrate | ~12–18 | ~600–900 · gated | `GroupScheme.IdentityComponent` (NEW PROJECT MATERIAL — see Open Qs); `LocallyConstantPushforward` | substrate not in Mathlib |
| **A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface API** | chapter landed; shares with RR.1 | ~30–50 | ~1500–2500 · gated | codim-1 indeterminacy; Weil-divisor surface; valuative criterion | dominant Route-A risk |
| **A.4.b — Auslander–Buchsbaum import** | chapter + file-skeleton landed | ~10–14 | ~500–700 · gated | depth, projective dimension | Mathlib partial; depth missing |
| **A.4.c — Thm 3.2 rational-map-extension assembly** | chapter + file-skeleton landed | ~12–18 | ~600–900 · gated | bundles A.4.a + A.4.b | small assembly |
| **A.4.d.i — `Sym^g C` sub-build** | chapter landed (Albanese_AlbaneseUP §Sym^g); unowned `S_g`-quotient substrate | ~8–14 | ~400–700 · gated | quotient by S_g; smoothness/properness; functor of points | new project material |
| **A.4.d.ii — Albanese UP wiring** | chapter landed; Sym^g route ii committed | ~4–8 | ~200–400 · gated | uses A.4.d.i + A.3 + A.4.c | small assembly once Sym^g lands |
| **Genus-0 rigidity — `gmScalingP1` body chain** | active body — STRICT one-shot of option (a) with HARD STOP this iter | 1 (HARD STOP) | ~80–150 · ~0/it (5 iters realized) | chart-bridge structural pivot; `Scheme.Cover.glueMorphisms` | if Lane A1 closes 0 Step C sorries with option (a) on file, iter-177 commits to temporary-axiom OR differential char-0 fallback (see Open Qs) |
| **Genus-0 RR.1 — Weil divisors** | active body | ~5–9 | ~250–450 · ~30/it | divisors at scheme level; closed-point order; degree map | parallel-startable RR entry |
| **Genus-0 RR.2 — RR formula for genus 0** | chapter + file-skeleton landed | ~8–12 | ~400–600 · ~0/it | finite-rank cohomology; Euler-char; SES additivity (gap) | dimension-count engine |
| **Genus-0 RR.3 — `O_C(P)` global sections** | chapter landed | ~8–12 | ~400–600 · gated | invertible sheaf at point; restriction sequence | extracts non-constant function |
| **Genus-0 RR.4 — rational ⟹ `≅ ℙ¹`** | chapter landed | ~8–12 | ~400–600 · gated | `Proj.fromOfGlobalSections`; degree-1 iso | finishes the bridge |
| `genusZeroWitness` body + `k̄→k` descent | gated on genus-0 rigidity + RR bridge | ~7–10 | ~350–850 · gated | terminal cluster on Spec k; faithfully-flat descent | descent direction LOCKED to Spec-k-direct (see Open Qs) |
| `nonempty_jacobianWitness` body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

**Total positive-genus arm (Route A, in-tree build)**: ~185–340 iters /
~9000–16000 LOC.
**Total positive-genus arm (Route A, axiomatise-staging path)**: ~25–35
iters / ~2000–3000 LOC (admits temporary axioms for the unowned-substrate
items; see Open Qs).
**Total genus-0 arm**: ~30–50 iters / ~1880–3400 LOC (factor in honest
RR gating).

## Routes

Positive-genus arm = **Route A (Picard scheme via FGA)** — mandatory.
Genus-0 arm = **Route C (Milne §I.3 rigidity)** — `J = Spec k` trivial,
char-general.

### Route A — Picard scheme via FGA

`J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6. A.2 +
A.4 decomposed (A.2.a.i/ii/iii, A.2.b.i/ii/iii, A.4.a/b/c/d.i/d.ii) per
table. A.4.a = dominant risk; A.4.b independently startable.

Dependency graph: A.1.b ⊳ A.1.a; A.1.c ⊳ A.1.b; A.2.a.ii ⊳ A.2.a.i;
A.2.a.iii ⊳ A.2.a.ii; A.2.b.ii ⊳ A.1.a + A.2.a.i; A.2.b.iii ⊳ A.2.b.i +
A.2.b.ii; A.2.c ⊳ A.2.b.iii + A.1.c; A.3 ⊳ A.2.c; A.4.c ⊳ A.4.a +
A.4.b; A.4.d.ii ⊳ A.4.d.i + A.3 + A.4.c. Parallel-startable lanes
named in `## Phases & estimations`.

### Route C — genus-0 rigidity via Milne §I.3

`J = Spec k` trivial. Over `k̄`, every pointed `f : C → A` is constant.
Rigidity Lemma + Cor 1.5 + Cor 1.2 axiom-clean. Base case `ℙ¹→A const`
via **`𝔾_m`-scaling shortcut**: `σ_×` fixes `0`, Cor 1.5 collapses
W-axis ⟹ `f(λx)=f(x)`; density of `𝔾_m` in `ℙ¹` + `ext_of_isDominant`
⟹ constant. Genus-0 ⟹ ℙ¹ via RR bridge. NO cube, NO Thm 3.2, NO
Auslander–Buchsbaum, NO diff/Frob; char-general.

## Open strategic questions

- **`k̄→k` descent — LOCKED to Spec-k-direct.** Genus-0 witness body
  proves UP directly over `Over (Spec k)` at the structural morphism
  `C → Spec k`; faithfully-flat descent along `Spec k̄ → Spec k`. No
  intermediate `C_{k̄} ≅ ℙ¹`. Reversal: descent-step block reconsiders
  via `C_{k̄} ≅ ℙ¹`.
- **A.4.a ↔ RR.1 shared material.** Codim-1 order, divisor degree
  shared via `RiemannRoch/WeilDivisor.lean` (RR.1 populates,
  A.4.a consumes). Cross-reference audit owed.
- **Axiomatise-then-replace — Route A.** Admit temporary `axiom`s for
  unowned-substrate needs (Stacks 052H, Grassmannian, Quot, FGA Pic
  representability, `GroupScheme.IdentityComponent`, Sym^g/`S_g`),
  marked `-- TODO: replace by Mathlib upstream`. Collapses critical
  path from ~185–340 iters to ~25–35 for a *working* axiomatised
  build. TRACKED, NOT COMMITTED. Trigger: if Route A velocity stays
  ~0/it on file-skeleton lanes for two consecutive iters, escalate via
  `TO_USER.md`.
- **Axiomatise-then-replace — Route C (parity).** Symmetric option:
  admit `axiom gmScalingP1_constant` (or the analogous statement the
  rigidity-over-k̄ proof consumes), `-- TODO: replace by chart-bridge
  body`. Finishes genus-0 witness arm in 1–2 iters, isolating
  chart-bridge as contained debt. TRACKED, ARMED for HARD STOP (see
  next).
- **Lane A1 HARD STOP rule.** Chart-bridge has been at ~0/it × 5 iters.
  This iter dispatches one final STRICT one-shot of analogist option
  (a) `simp only [Fin.isValue, Fin.zero_eta]` / `Fin.mk_one`
  (empirically verified by the analogist via `lean_multi_attempt`; the
  prior prover never actually applied it before a session-limit reset
  hit). HARD STOP: if Lane A1 returns 0 Step C sorry closures with
  option (a) verifiably ON FILE, next iter SAME-ITER commits to (a)
  `TO_USER.md` escalation surfacing the temporary-axiom option, AND
  (b) opens a concurrent prover lane on the
  `temporary axiom gmScalingP1_constant` path. NO 6th retry.
- **Differential `H⁰(ℙ¹, O(-2)) = 0` char-0 sub-case.** Fallback for
  genus-0 base. NOT a full goal-solution: protected signatures take
  `[Field k]` only (no `CharZero`), so this is partial coverage at
  best. Status: AVAILABLE-AS-CONCURRENT-LANE if HARD STOP fires; must
  be COMBINED with a char-`p` arm (Frobenius descent / Witt-vector) to
  satisfy `[Field k]`. NOT a strict chart-bridge replacement.
- **REJECTED alternatives** (recorded so re-planners don't re-litigate):
  `Sym^g`/theta-divisor Jacobian (needs `k`-rational base-point; no
  `Sym^g` in Mathlib); `Pic⁰`-functor-of-points Albanese-UP (shifts
  codim-1 content rather than eliminates).
- **OPEN literature consult**: `Pic⁰` via abstract sheafification of
  `Pic⁰` on the étale site (skip Quot)? Owed reference check —
  does sheafification produce a scheme outside char-0/k-finite?

## Mathlib gaps & new material

**Gaps to fill (CRITICAL PATH — Route A engine; all UNOWNED in Mathlib).**
LOC = remaining build size; PATH = project owner file.

- A.1.a `RelativeSpec` functor. ~200–400 LOC.
  PATH `AlgebraicJacobian/Picard/RelativeSpec.lean` (skeleton landed).
- A.1.b Line-bundle pullback on `C ×_k T`. ~200–400 LOC.
  PATH `AlgebraicJacobian/Picard/LineBundlePullback.lean` (skeleton landed).
- A.1.c Relative Picard presheaf + ét-sheafification. ~300–500 LOC.
  PATH `AlgebraicJacobian/Picard/RelPicFunctor.lean` (skeleton dispatching).
- A.2.a Flattening stratification (Stacks 052H). ~2000–3500 LOC.
  PATH `AlgebraicJacobian/Picard/FlatteningStratification.lean` (skeleton dispatching).
- A.2.b Quot + Grassmannian (Nitsure §5). ~2600–5000 LOC.
  PATH `AlgebraicJacobian/Picard/QuotScheme.lean` (skeleton dispatching).
- A.2.c FGA `Pic_{C/k}` assembly. ~600–800 LOC.
  PATH `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (skeleton dispatching).
- A.3 `Pic⁰` + degree. ~600–900 LOC. Substrate `GroupScheme.IdentityComponent`
  UNOWNED. PATH `AlgebraicJacobian/Picard/IdentityComponent.lean` NEW
  (not yet scaffolded — owed iter-177+).
- A.4.a Lemma 3.3 codim-1 + Weil-divisor surface. ~1500–2500 LOC.
  PATH `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (chapter
  landed; skeleton deferred).
- A.4.b Auslander–Buchsbaum. ~500–700 LOC.
  PATH `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` (skeleton landed).
- A.4.c Thm 3.2 rational-map-extension. ~600–900 LOC.
  PATH `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` (skeleton landed).
- A.4.d.i `Sym^g` of schemes (`S_g`-quotient substrate UNOWNED).
  ~400–700 LOC. PATH `AlgebraicJacobian/Albanese/SymmetricPower.lean`
  NEW (not yet scaffolded — owed iter-177+).
- A.4.d.ii Albanese UP wiring. ~200–400 LOC.
  PATH `AlgebraicJacobian/Albanese/AlbaneseUP.lean` (chapter landed; skeleton deferred).

**Gaps to fill (genus-0 rigidity — Route C):**

- `σ_×:ℙ¹×𝔾_m→ℙ¹` body. Recipe in
  `analogies/chart-bridge-structural-pivot.md`.
  PATH `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane A1 active).
- genus-0 + k̄-point ⟹ `≅ ℙ¹`. RR.1/RR.2/RR.3/RR.4 under
  `AlgebraicJacobian/RiemannRoch/`.
- No `AbelianVariety` / no general Riemann–Roch in Mathlib (both verified absent).

**New project material introduced (summary; full paths above):**
AbelianVarietyRigidity, RigidityLemma, Genus0BaseObjects/{BareScheme,
ChartIso, Points, GmScaling}, Rigidity, RiemannRoch/{WeilDivisor,
RRFormula, OCofP, RationalCurveIso}, Picard/{RelativeSpec,
LineBundlePullback, FlatteningStratification, RelPicFunctor, QuotScheme,
FGAPicRepresentability, IdentityComponent (planned)}, Albanese/{AuslanderBuchsbaum,
Thm32RationalMapExtension, CodimOneExtension, AlbaneseUP, SymmetricPower (planned)}.

```

## references/summary.md (verbatim)

```
# References

<!-- archon:references-summary -->

| File | Description |
| ---- | ----------- |
| `challenge.lean.ref` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
| [`stacks-varieties.md`](./stacks-varieties.md) → `stacks-varieties.tex` | Stacks ch.33 "Varieties" — tags **035U** (§geom-reduced), **04QM**/**056T** (smooth over fields ⇒ geom regular/normal/reduced), **0BUG** (8-part `H^0(X,𝒪)` lemma, part (4) geom-reduced⇒separable). Backs (S3.sep.*). |
| [`stacks-fields.md`](./stacks-fields.md) → `stacks-fields.tex` | Stacks ch.9 "Fields" — tags **09HD** (§purely inseparable), **030K** (separable-then-inseparable factorisation). Backs (S3.pi.2). |
| [`stacks-algebra.md`](./stacks-algebra.md) → `stacks-algebra.tex` | Stacks ch.10 "Commutative Algebra" — tag **00T7** (standard smooth ⇒ `Ω_{S/R}` free on `dx_{c+1},…,dx_n`), L37259. Backs (BR.2)–(BR.5). Large file: jump to line. |
| [`stacks-coherent.md`](./stacks-coherent.md) → `stacks-coherent.tex` | Stacks ch.30 "Cohomology of Schemes" — tag **02KH** (flat base change of `R^i f_*`; part (2) `H^0`-with-base-change). Backs (S3.pi.1). |
| [`stacks-constructions.md`](./stacks-constructions.md) → `stacks-constructions.tex` | Stacks ch.27 "Constructions of Schemes" — tags **01LL**/**01LO**/**01LQ**/**01LR**/**01LS** (relative-spectrum chapter: situation, glueing, functor `F`, base change). **Caveat**: 01LL is a SECTION label, 01LO is the transitivity (NOT affine-case) lemma, 01LR is the eqn defining `F`. Adjacent tags **01LM** (situation-relative-spec), **01LP** (lemma-glue-relative-spec), **01LT** (lemma-spec-affine = the affine base case) are the likely real quote targets — see pointer file caveats. Backs `Picard_RelativeSpec.tex` (iter-171). |
| [`kleiman-picard.md`](./kleiman-picard.md) → `kleiman-picard.pdf` / `-src/*.tex` | Kleiman, "The Picard scheme" (FGA Explained / arXiv:math/0504020). Route A source. **Deep map**: §4 existence, §5 `Pic⁰` (Jacobian, pp.36–51), §6 `Pic^τ` finiteness. |
| [`nitsure-hilbert-quot.md`](./nitsure-hilbert-quot.md) → `nitsure-hilbert-quot.pdf` / `-src/*.tex` | Nitsure, "Construction of Hilbert and Quot Schemes" (FGA Explained / arXiv:math/0504590). Quot/Hilbert construction engine behind Route A. |
| [`abelian-varieties.md`](./abelian-varieties.md) → `abelian-varieties.pdf` | Milne, "Abelian Varieties" (course notes, 2008). **Rigidity Theorem 1.1** (§I.1, p.8); **Thm 3.2** + **Prop 3.10** "rational/unirational → AV is constant" = `Mor(ℙ¹,A)` constant via bare rigidity, NO Serre duality (§I.3, pp.15–20); **theorem of the cube** §I.5 p.21; **Albanese universal property** of `Pic⁰`/Jacobian **Prop 6.1/6.4** (§III.6, p.104). |
| [`mumford-abelian-varieties.md`](./mumford-abelian-varieties.md) → `mumford-abelian-varieties.pdf` | Mumford, "Abelian Varieties" (TIFR, 1970). **THE canonical route-(c) source.** **Rigidity Lemma (Form I)** + Cor.1 (§4, book p.43 / PDF p.54); **abelian-variety definition + conventions** (§4, p.39); **Theorem of the Cube** §6 p.55 (PDF p.66), scheme version §10 p.89. Offset +11 (body). Scanned image PDF — no text layer; quote from rendered page. "Mor(ℙ¹,A) constant" NOT separately labeled here (use Milne Prop 3.10). |
| [`hartshorne-algebraic-geometry.md`](./hartshorne-algebraic-geometry.md) → `hartshorne-algebraic-geometry.pdf` | Hartshorne, "Algebraic Geometry" (GTM 52, 1977). **Genus-0 curve ≅ ℙ¹**: Example IV.1.3.5 (doc p.297 / PDF p.314) + Exercise IV.1.3 (rational-point form); **genus def `g=dim H¹(O_X)`**: Prop IV.1.1 (doc p.294). **`Ω_{ℙ¹}≅O(−2)`**: Euler seq Thm II.8.13 (p.176) + ω_{ℙⁿ}≅O(−n−1) Ex.II.8.20.1 (p.182). **`H⁰(ℙ¹,O(−2))=0`**: Thm III.5.1(a) (p.225). Offset +17 (body). Scanned image PDF. |
| [`fga-explained.md`](./fga-explained.md) → `fga-explained.pdf` | Fantechi–Göttsche–Illusie–Kleiman–Nitsure–Vistoli, "FGA Explained" (AMS MSM 123, 2005). Route A engine, collected volume. **Kleiman Picard** = Ch.9 (book p.237): §9.4 existence p.262, §9.5 Pic⁰ p.275. **Nitsure Hilbert/Quot** = Ch.5 (p.107): §5.5 Quot construction p.126. **Vistoli descent/Yoneda** Ch.2 §2.1 p.13, Ch.4 stacks p.67. **Illusie Grothendieck existence** Ch.8 §8.4 p.204. Offset +10. Has text layer. Book numbering differs from arXiv `kleiman-picard`/`nitsure-hilbert-quot` cards. |

```

## Blueprint summary (chapter titles + one-line topics)

```
- AbelJacobi.tex: The Abel--Jacobi map
- AbelianVarietyRigidity.tex: Abelian-variety rigidity: morphisms from a genus-$0$ curve into an abelian variety are constant
- Albanese_AlbaneseUP.tex: The Albanese universal property of $\Pic^0_{C/k
- Albanese_AuslanderBuchsbaum.tex: Auslander--Buchsbaum
- Albanese_CodimOneExtension.tex: Codimension-1 indeterminacy extension (A.4.a)
- Albanese_Thm32RationalMapExtension.tex: Milne Theorem 3.2: Rational maps into abelian varieties
- AlgebraicJacobian_Cotangent_GrpObj.tex: Cotangent space at the identity (piece (i) --- Lean file)
- Cohomology_MayerVietoris.tex: Mayer--Vietoris long exact sequence for sheaf cohomology with $k$-module coefficients
- Cohomology_SheafCompose.tex: Sheaf condition along the structure-sheaf forget composite
- Cohomology_StructureSheafAb.tex: Structure sheaf as a sheaf of abelian groups, sheafification and Ext
- Cohomology_StructureSheafModuleK.tex: Sheaves of $k$-modules: sheafification, Ext, and the structure sheaf as a sheaf of $k$-modules
- Differentials.tex: The relative cotangent presheaf
- Genus.tex: Genus of a smooth proper curve
- Jacobian.tex: The Jacobian as an abelian variety
- Picard_FGAPicRepresentability.tex: FGA representability of the Picard scheme
- Picard_FlatteningStratification.tex: Flattening Stratification of a Coherent Sheaf
- Picard_LineBundlePullback.tex: Line-bundle pullback on a relative curve
- Picard_QuotScheme.tex: The Quot scheme
- Picard_RelPicFunctor.tex: The relative Picard functor and its \'etale sheafification
- Picard_RelativeSpec.tex: Relative Spec
- RiemannRoch_OCofP.tex: The line bundle $\mathcal O_C(P)$ and its global sections (RR.3)
- RiemannRoch_RRFormula.tex: The Riemann--Roch formula in genus zero (RR.2)
- RiemannRoch_RationalCurveIso.tex: The rational-curve isomorphism $C \cong \mathbb P^1$ (RR.4)
- RiemannRoch_WeilDivisor.tex: Weil divisors on a smooth proper curve (RR.1)
- Rigidity.tex: Rigidity for morphisms of schemes (scheme-level form; Mumford \S4 in the abelian-variety case)
- RigidityKbar.tex: Rigidity over a base field $k$: morphisms from a genus-$0$ curve to a group scheme are constant
```

## Returns

Per your descriptor, return one verdict: **SOUND** (proceed) /
**CHALLENGE** (specific concerns) / **REJECT** (route abandonment
recommended). Address:

- Whether the per-sub-phase decomposition for Route A (A.1.a/b/c,
  A.2.a.i/ii/iii, A.2.b.i/ii/iii, A.2.c, A.3, A.4.a/b/c/d.i/d.ii)
  remains the right shape — or whether some sub-phase is dead weight,
  unrealistic, or covers what mathlib upstream now does.
- Whether the `Total positive-genus arm (Route A, in-tree build):
  ~185–340 iters / ~9000–16000 LOC` estimate is realistic given the
  unowned-substrate items (Stacks 052H, Grassmannian, Quot, FGA Pic
  representability, `GroupScheme.IdentityComponent`, `Sym^g`).
- Whether the Route C HARD STOP rule (locked in `## Open strategic
  questions`) is appropriate, given that the genus-0 chart-bridge is
  the only blocker for the genus-0 arm.
- Whether the axiomatise-then-replace option is healthy under the
  project rule "No new axioms" (read it together with the rule that
  notes "If axioms are already present, remove them" — the Open Q's
  `-- TODO: replace by Mathlib upstream` marker is intended to make
  the axiom temporary).
- Whether the `genus0 (`RR.1`/`RR.2`/`RR.3`/`RR.4`) arm decomposition
  remains coherent.

Drop any sub-phase you think is dead weight.

## Format hard rules (per descriptor)

Your report must respect the STRATEGY.md format envelope:
- one short line per table cell
- no per-iter narrative
- no Lean code, no blueprint excerpts
- ≤ ~12 KB if any restructure proposal is made

If you propose a STRATEGY.md restructure, give a concrete patch — not
just "rewrite the cells".
