# Strategy Critic Directive

## Slug
ts213

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge (references/challenge.lean.ref): nine protected declarations headed by AlgebraicGeometry.Jacobian and Jacobian.nonempty_jacobianWitness — an Albanese/Jacobian object uniform over the k-rational pointing of a smooth proper geometrically irreducible curve C/k ([Field k] only; no C(k)≠∅, no CharZero). J := Pic⁰_{C/k} is built unconditionally; only isAlbaneseFor is quantified over the pointing.

## STRATEGY.md (verbatim)

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): the nine
protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the `k`-rational
pointing of a smooth proper geometrically irreducible curve `C/k` (`[Field k]` only; no
`C(k)≠∅`, no `CharZero`). `J := Pic⁰_{C/k}` is built unconditionally; only `isAlbaneseFor` is
quantified over the pointing. Spine: pointed vs. unpointed.

**Posture — option (c).** Forward the Route-A Picard substrate while Riemann–Roch stays frozen
by the USER ROUTE C PAUSE. The nine protected decls typecheck modulo named sorry-axioms (0
project axioms; none yet kernel-clean). RR-pause price: two RR-free obligations that are large
or unverified — the general Quot engine and Route-2 autoduality (see Open questions).

## Phases & estimations

| Phase | Status | Iters left | LOC (rem · /it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| A.1.c.SubT — line-bundle ⊗-group law | active; assoc on **route (c)** (3 realizations dead) | ~3–6 | ~150–300 · ~0/it* | local-on-cover `IsLocallyInjective` of whiskered `toSheafify`; `Units(Skeleton)` iso-class group | med: route (c) is the LAST viable associator realization |
| A.1.c — RelPic functor | held (placeholder bodies) | ~3–5 | ~50–150 · 0/it | A.1.c.SubT iso-class group; ét-sheafify on `Over S` | RE-ENGAGE: replace dishonest `PicSharp := const PUnit` + `functorial := 0` |
| A.2.c — Pic representability (scaffolding) | priority-2 | ~12–16 | ~600–800 · 0/it | A.1.c | `⟨sorry⟩` constructors discharged only by the engine below |
| A.2.c-engine — general Quot/Cartier (RR-free) | **HOLD pending USER RR decision** | ~30–60 | ~3400–5500 · 0/it | R^i f_* (i≥1), Relative Proj, CM-regularity, Grassmannian, flattening | largest build; 2–4× cheaper RR route exists behind the pause |
| A.3.0/ii/vii — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | ~1100–2100 · 0/it | scheme tangent space; Hilbert poly | absent in Mathlib; likely under-counted |
| A.4 — Albanese UP (Route 2) | gated A.2.c; autoduality RR-freeness UNVERIFIED | ~12–20 | ~600–1000 · 0/it | `rmk:Alb` + autoduality `J^∨≅J` + Galois descent | if autoduality needs RR, collides with paused Route C |
| genusZero + witness body | gated A.3 | ~5–7 | ~250–450 · 0/it | tangent-iso + connectedness | hidden A.2.c transit |

`*` SubT helpers (gate, bridge, unitors, braiding) landed axiom-clean iters 211–212, but the
load-bearing associator existence-iso is still open (0/it on the target). **Total Route A**:
~90–170 iters / ~4000–7000 LOC (RR-free engine path).

## Routes

`J := Pic⁰_{C/k}` (Kleiman §4–5, Nitsure §5, Milne III §6). Bottom-up (USER): ungated roots
first, no gated target before its roots, no A.3+ before A.2.c. Every directive cites
Kleiman/Nitsure/Milne/Mumford/Hartshorne/Stacks. **Critical path (RR-free):** A.1.c.SubT →
A.1.c → A.2.c.

**A.1.c.SubT — group law via ⊗-invertibility.** Pic = `Units` of the monoid of ⊗-iso-classes
of locally-trivial `Scheme.Modules` (mirrors `CommRing.Pic`). Iso-class axioms are
propositions, so only the existence-of-iso lemmas are needed — no coherent monoidal category, no
`MonoidalClosed`. Unitors/braiding via `sheafification.mapIso` (done). Associator = the 3-step
absorb→associate→absorb composite; via the closed bridge `isIso_sheafification_map_of_W` it
reduces to "the whiskered sheafification unit `η ▷ P` lies in `J.W`". Three realizations are
DEAD: bundled monoidal (`MonoidalClosed (PresheafOfModules R₀)` absent), flat-exactness
whiskerLeft (needs sectionwise flatness, FALSE for invertibles on non-affine opens),
`tensorObj_restrict_iso` (strong-monoidal pushforward absent). **Live = route (c):** local
injectivity of `η ▷ P` checked on a trivializing cover — presheaf-level, needs NEITHER flatness
NOR restrict-iso — scoped to `IsLocallyTrivial` (the consumers already use it).

**A.2.c — representability + Quot fork (held).** Six Prop-valued typeclasses with `⟨sorry⟩`
constructors scaffold representability (~600–800 LOC); Route A proceeds under them. Discharge
fork: RR-free general Quot/Hilbert engine (Nitsure §5 + Kleiman §4, ~3400–5500 LOC, all
Mathlib-absent; deepest root `R^i f_*`, i≥1) vs cheap curve route (Kleiman §5, `Sym^n`/Abel–
Jacobi, ~600–1000 LOC, needs paused RR). Engine HELD behind A.1.c.SubT→A.1.c.

**Albanese UP — Route 2.** UP from `Pic` representability via Kleiman `rmk:Alb` (RR-free) on the
dual `J^∨`, landed on `J` by autoduality `J^∨≅J` (Milne 6.6 / EGK 2.1) + Galois descent `k̄→k`
(Milne 6.4). Supersedes the Route-1 codim cone, retained reversibly with the deletion gate
closed until autoduality RR-freeness is re-verified (theta divisor rests on RR — top risk).

**Route C — Riemann–Roch — PAUSED (USER).** Imported with inline sorries (option c). Needed at
the three Goal nodes; would unlock the cheap curve route. Pause cost: the ~3400+ LOC engine and
the autoduality risk exist solely to avoid RR.

**Genus-0 arm.** (a) Route-A Pic⁰-via-AV-wrap (transits A.2.c); (b) direct `J := Spec k` via
Mumford rigidity — substrate partial, PAUSED (USER).

## Open strategic questions

- **A.1.c.SubT route-(c) survival:** route (c) is the LAST viable associator realization. Its
  one new dependency — local-on-cover `IsLocallyInjective` of the whiskered `toSheafify` — is
  unverified-hard? If it bottoms out, the `tensorObj = sheafification(presheaf tensor)`
  substrate design itself is forced and should be escalated to USER.
- **Iso-class group carrier — `IsInvertible` vs `IsLocallyTrivial`:** route (c) and all
  consumers use `IsLocallyTrivial`; the group carrier may follow, deferring `IsInvertible ⇒
  IsLocallyTrivial` (standard, but blueprint-flagged nontrivial) off the critical path.
- **A.2.c — pay for RR or build the RR-free substitute (USER decision, priced):** keep pause ⇒
  ~3400–5500 LOC Quot engine + autoduality risk; lift ⇒ ~600–1000 LOC `Sym^n`/Abel–Jacobi slice.
- **Autoduality `J^∨≅J` RR-freeness** (EGK 2.1 / Poincaré bundle): second-verify before any
  Route-2 investment — classically RR-dependent; if it transits RR the RR-free posture fails.
- **`k̄→k` Galois descent** at the no-`C(k)` heart: verify per-pointing `isAlbaneseFor` composes
  with descent + autoduality before treating it as minor.
- **`R^i f_*` (i≥1) treatment** (gates the engine): Mathlib PR vs project Čech build (~800–1200)
  vs named typed-sorry pin. Decide when the engine de-gates.

## Mathlib gaps & new material

**Gaps to fill (Route A).**
- A.1.c.SubT: local-on-cover `IsLocallyInjective` of the whiskered sheafification unit (route
  (c)); `Units(Skeleton)`-shaped CommMonoid/group on ⊗-iso-classes of locally-trivial bundles
  (~150–300). Dead-end (do NOT re-attempt): sectionwise flatness from `IsInvertible`.
- A.1.c: ét-sheafify on `Over S`; `OnProduct` re-point to the locally-trivial subtype.
- A.2.c-engine (HELD): `R^i f_*` (i≥1), Relative Proj, geometric Hilbert poly, CM-regularity,
  semi-continuity, flattening, Grassmannian, Quot representability, relative Cartier (~3400–5500).
- A.3 / A.4: scheme tangent space, Hilbert poly, Pic⁰ AV-structure; `rmk:Alb` UP, autoduality,
  Galois descent.

**New project material.** AbelianVarietyRigidity, RigidityLemma, Genus0BaseObjects/*, RiemannRoch/*
(paused), Picard/{RelativeSpec, LineBundlePullback, RelPicFunctor, FGAPicRepresentability,
IdentityComponent, Pic0AbelianVariety, QuotScheme, FlatteningStratification, TensorObjSubstrate},
Albanese/AlbaneseUP. Route-1 cone retained reversibly behind the closed deletion gate.
```

## references/summary.md (verbatim)

```markdown
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
| [`leinster-basic-category-theory.md`](./leinster-basic-category-theory.md) → `leinster-basic-category-theory.pdf` | Leinster, "Basic Category Theory" (CUP CSAM 143, 2014; arXiv:1612.09375). **Ch. 4** Yoneda / representables; **Ch. 5** limits / colimits. Backs categorical pre-substrate: sheafification, fibered-product UPs, representability of Pic/Quot. | `Read` (with `pages: "1-10"` etc.) |
| [`atiyah-macdonald-commutative-algebra.md`](./atiyah-macdonald-commutative-algebra.md) → `atiyah-macdonald-commutative-algebra.pdf` | Atiyah–Macdonald, "Introduction to Commutative Algebra" (Addison-Wesley, 1969). **Ch. 8** primary decomposition; **Ch. 11** Krull dimension. Lightweight companion to Matsumura for codim-1 reasoning in `CodimOneExtension.lean` and Weil-divisor surface API. | `Read` (with `pages: "1-10"` etc.) |
| [`matsumura-commutative-ring-theory.md`](./matsumura-commutative-ring-theory.md) → `matsumura-commutative-ring-theory.pdf` | Matsumura, "Commutative Ring Theory" (CUP CSAM 8, 1987; Reid translation). **Ch. 16–17** depth / regular sequences / Cohen–Macaulay; **Ch. 19** Auslander–Buchsbaum formula / regular local rings. Direct dependency of `AuslanderBuchsbaum.lean` and `CodimOneExtension.lean`. | `Read` (with `pages: "1-10"` etc.) |
| [`stacks-modules.md`](./stacks-modules.md) → `stacks-modules.tex` | Stacks ch.17 "Modules on Ringed Spaces" — **tag 01CR** = §17.25 "Invertible modules" (lines 4038–4411): Def 01CS (invertible module via tensor-equivalence functor, line 4047), Lemma 0B8K (∃N characterisation $\mathcal{L}\otimes\mathcal{N}\cong\mathcal{O}_X$, line 4067), tag 01CX (Picard group $\Pic(X)$ as abelian group under ⊗, line 4351). Backs `Picard_TensorObjSubstrate.tex`. | `Read` (lines 4038–4411) |
| [`stacks-divisors.md`](./stacks-divisors.md) → `stacks-divisors.tex` | Stacks ch.31 "Divisors" — Cartier/Weil divisors, $c_1:\Pic(X)\to\text{Cl}(X)$, norm maps. **Tag 01CR is NOT here** (it is in stacks-modules.tex). Useful for §31.28 Weil-divisor-class-vs-Pic map (line 6707) and §31.29 Picard groups of UFD/projective space (line 6961). | `Read` (by line number) |
```

## Blueprint chapter index (title = one-line topic per chapter)

- AbelJacobi.tex: \chapter{The Abel--Jacobi map}
- AbelianVarietyRigidity.tex: \chapter{Abelian-variety rigidity: morphisms from a genus-\(0\) curve into an abelian variety are constant}
- Albanese_AlbaneseUP.tex: \chapter{The Albanese universal property of \(\Pic^0_{C/k}
- Albanese_AuslanderBuchsbaum.tex: \chapter{Auslander--Buchsbaum}
- Albanese_CodimOneExtension.tex: \chapter{Codimension-1 indeterminacy extension (A.4.a)}
- Albanese_CoheightBridge.tex: \chapter{Coheight--Krull dim bridge for scheme points}
- Albanese_Thm32RationalMapExtension.tex: \chapter{Milne Theorem 3.2: Rational maps into abelian varieties}
- AlgebraicJacobian_Cotangent_GrpObj.tex: \chapter{Cotangent space at the identity (piece (i) --- Lean file)}
- Cohomology_MayerVietoris.tex: \chapter{Mayer--Vietoris long exact sequence for sheaf cohomology with \(k\)-module coefficients}
- Cohomology_SheafCompose.tex: \chapter{Sheaf condition along the structure-sheaf forget composite}
- Cohomology_StructureSheafAb.tex: \chapter{Structure sheaf as a sheaf of abelian groups, sheafification and Ext}
- Cohomology_StructureSheafModuleK.tex: \chapter{Sheaves of \(k\)-modules: sheafification, Ext, and the structure sheaf as a sheaf of \(k\)-modules}
- Differentials.tex: \chapter{The relative cotangent presheaf}
- Genus.tex: \chapter{Genus of a smooth proper curve}
- Genus0BaseObjects_Cross01Substrate.tex: \chapter{Cross01 Substrate}
- Jacobian.tex: \chapter{The Jacobian as an abelian variety}
- Picard_FGAPicRepresentability.tex: \chapter{FGA representability of the Picard scheme}
- Picard_FlatteningStratification.tex: \chapter{Flattening Stratification of a Coherent Sheaf}
- Picard_IdentityComponent.tex: \chapter{The identity component of the Picard scheme}
- Picard_LineBundlePullback.tex: \chapter{Line-bundle pullback on a relative curve}
- Picard_Pic0AbelianVariety.tex: \chapter{The identity component \(\Pic^0_{C/k}
- Picard_QuotScheme.tex: \chapter{The Quot scheme}
- Picard_RelPicFunctor.tex: \chapter{The relative Picard functor and its \'etale sheafification}
- Picard_RelativeSpec.tex: \chapter{Relative Spec}
- Picard_TensorObjSubstrate.tex: \chapter{Relative Picard sheaf --- \texttt{Scheme.Modules.tensorObj}
- RiemannRoch_H1Vanishing.tex: \chapter{Vanishing of \(H^1\) for skyscraper sheaves on a curve (RR.2.H\(^1\))}
- RiemannRoch_OCofP.tex: \chapter{The line bundle \(\mathcal O_C(P)\) and its global sections (RR.3)}
- RiemannRoch_OcOfD.tex: \chapter{The invertible sheaf \(\mathcal O_C(D)\) of a Weil divisor (RR.2\(_\ast\))}
- RiemannRoch_RRFormula.tex: \chapter{The Riemann--Roch formula in genus zero (RR.2)}
- RiemannRoch_RationalCurveIso.tex: \chapter{The rational-curve isomorphism \(C \cong \mathbb P^1\) (RR.4)}
- RiemannRoch_WeilDivisor.tex: \chapter{Weil divisors on a smooth proper curve (RR.1)}
- Rigidity.tex: \chapter{Rigidity for morphisms of schemes (scheme-level form; Mumford \S4 in the abelian-variety case)}
- RigidityKbar.tex: \chapter{Rigidity over a base field \(k\): morphisms from a genus-\(0\) curve to a group scheme are constant}

## Focus question for this dispatch

The strategy changed substantively this iter on ONE point: the A.1.c.SubT associator's load-bearing realization. The flat-exactness whiskerLeft realization is now DEAD (its hypothesis is sectionwise flatness over all opens, FALSE for invertible sheaves on non-affine opens — confirmed by the iter-212 prover, the lean-vs-blueprint-checker, and a mathlib-analogist API-alignment consult this iter). Mathlib supplies NEITHER a monoidal SheafOfModules NOR a monoidal sheafification (both gated on absent MonoidalClosed (PresheafOfModules R₀)), and the tensorObj_restrict_iso realization was abandoned earlier. The strategy now commits the associator to 'route (c)': prove the whiskered sheafification unit lies in J.W by checking local injectivity on a trivializing cover (presheaf-level; needs neither flatness nor restrict-iso), scoping the lemma to IsLocallyTrivial. Please assess: (1) Is committing the LAST viable associator realization (3 of 4 dead) sound, or is this a sunk-cost trap where the tensorObj = sheafification(presheaf tensor) substrate design itself should be escalated/redesigned? (2) Is scoping the iso-class group to IsLocallyTrivial (deferring IsInvertible ⇒ IsLocallyTrivial off the critical path) sound, given the consumers already use IsLocallyTrivial? (3) Any other route/fork/estimate concern in the current STRATEGY.md.
