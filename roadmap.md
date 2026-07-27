# LeanAG — Scope Roadmap (condensed)

A high-level, mathematical checklist across the scope's member projects.

**Legend:**

- [x] proved / sorry-free (or, for a theme, its keystone declarations are sorry-free)
- [~] in progress (declarations exist, residual `sorry`)
- [ ] not started (no Lean yet — blueprint only, or theme not begun)

**Status snapshot** *(open `sorry` counts over each project's Lean source tree via a
comment-stripping pass — comments/docstrings excluded; measured 2026-07-27. The active loops move
these between pushes; the **[live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/)**
holds the authoritative per-node counts. All projects are on Lean/Mathlib `v4.31.0` with no
migration debt.)*

| Project | Stage | Open `sorry` |
| --- | --- | --- |
| Algebraic-Jacobian-Challenge-Rebuild | prover ✨ | 16 — 15 protected `Challenge.lean` targets + 1 in `Picard/Pic0ThetaCocycle.lean`. That file is imported from nowhere and has **never been elaborated** (no `.olean`/`.trace`), so its two theta coherences are unverified rather than proved; it is also not elaborable as written — 34 GB RSS and still climbing at 5 min, so it needs a split (roadmap `AJCR.w4-rep.build-reach`, `AJCR.w7-functor.k1`) |
| Algebraic-Jacobian-Challenge | prover | 26 *(grouped by the nested AJC roadmap below)* |
| Cech-Cohomology | ✅ complete · merged → AJC | 0 |
| GR-Quot-Closure | ✅ complete · merged → AJC | 0 |
| Line-Bundle-Comparison-Iso | ✅ complete · merged → AJC | 0 |
| Albanese | prover | 11 |
| Picard-IdentityComponent | prover | 16 |
| MR0555258-Compactifying-Picard | prover | 1 |

---

## Dependency spine

### Core algebraic-geometry engine

- `Line-Bundle-Comparison-Iso` → `Algebraic-Jacobian-Challenge` (the comparison-iso substrate giving `Pic♯` its group law; **merged sorry-free** ✨)
- `Albanese` → `Algebraic-Jacobian-Challenge` (Albanese universal property, codim-one & Thm 3.2 rational-map extension, Auslander–Buchsbaum/coheight bridge; merges back) ✨ 2026-06-20
- `Cech-Cohomology` ↔ `Algebraic-Jacobian-Challenge` (the Čech `Rⁱf_*` engine; **merged sorry-free** ✨ 2026-06-19, capstone `cech_computes_higherDirectImage` axiom-clean)
- `GR-Quot-Closure` → `Algebraic-Jacobian-Challenge` (Grassmannian-quotient representability H⁰ leg — `Grassmannian.represents`, SNAP section graded ring/module, cell-chart/glue-descent atlas; **merged sorry-free** ✨ 2026-06-22)
- `Picard-IdentityComponent` → `Algebraic-Jacobian-Challenge` (identity-component / `Pic⁰` group-scheme substrate)

### Related papers

`SubProjects/RelatedPapersFormalisation/` currently holds one registered project,
`MR0555258-Compactifying-Picard`; the broader related-paper catalogue is blueprint-stage and does
not feed the Jacobian-challenge critical path.

---

## Algebraic-Jacobian-Challenge-Rebuild  *(from-scratch rebuild — prover stage, 16 open `sorry`)* ✨

**Goal:** the EXTENDED challenge (core eight + `Jacobian.functor` + field base change with
cocycle coherence), rebuilt clean/general/mathlib-idiomatic per the `rebuild` task charter.
Route fixed in `informal/route-decision.md`: `J := Pic⁰` via the étale-sheafified Picard
functor (curve-specialized Kleiman, no Quot schemes), Albanese via Milne III.6.1,
`genus := dim_k H¹(C,𝒪_C)`.

- [x] **Wave 1 — curve substrate + genus lane, COMPLETE** ✨ *(2026-07-11)* — smooth ⇒
  geometrically reduced/integral; `Γ(C,𝒪_C) ≅ k`; ℙ¹ + Laurent charts; **finite `π : C → ℙ¹`**
  (`exists_isFinite_toP1`, via a new unramified-over-Dedekind brick, RationalMap spreading-out,
  topological quasi-finiteness + ZMT); `ModuleCat k` sheaf cohomology with affine `H¹'` vanishing;
  Mayer–Vietoris (0,1)-slice + two-cover `H1Cok` bridge (no affine-intersection hypothesis!);
  two-lattice ladder ⇒ **`Module.Finite k H¹(C,𝒪_C)`** — `genus` defined AND correct, axiom-clean.
- [x] **Wave 2 — rigidity (2a) and the χ-ledger / RR-lite (2b)** ✨ — Mumford Form-I rigidity +
  Milne I 1.2 (a pointed morphism of group schemes is a homomorphism), hypotheses weaker than
  Milne's; Euler-characteristic ledger complete.
- [x] **Wave 3 — relative Picard functor** ✨ — cocycle `Ȟ¹(𝒪ˣ)` carrier, étale-plus construction.
- [~] **Wave 4 — representability of `Pic⁰`** (active; `horizon roadmap list --focus AJCR.w4-rep`
  is the authoritative breakdown — the live gate is the DD-R certificate lane. Settled 2026-07-25:
  a certificate forces both pinned chart traces of the divisor closed, and the `Z(♦)` chart
  provably does *not* arrange that — the counterexample is field-independent. So the lane is on a
  coordinate twist of `π` (needs `Aut(ℙ¹)`, leaf `…certificate.p1-aut`), with one open question
  over small finite fields, leaf `…certificate.field-size` / inbox `I-0346`)
- [~] **Waves 5–7** — Pic⁰ abelian-variety package, Abel–Jacobi / Albanese, functoriality and
  base change of fields (each partly landed; see the structured roadmap)

Blueprint: Challenge/BaseChange/Curves/Algebra/Cohomology/AbelianVariety chapters all synced
1-to-1 with the Lean, `\leanok` only after kernel checks, `\source{}` read-before-cite.

## Algebraic-Jacobian-Challenge  *(core engine — prover stage, 26 open `sorry` in 11 of 172 modules)*

**Goal:** construct the Jacobian of a smooth proper geometrically integral curve as
`Pic^0`, prove that it is an abelian variety of dimension equal to the genus, and
establish the Albanese universal property. The structured roadmap command
`horizon roadmap list --focus AJC.jacobian` is the authoritative work breakdown.

*161 of the 172 modules are sorry-free; all 26 remaining `sorry`s live in 11 modules.*

- [x] **Foundational substrate** — `AJC.substrate`, seven sorry-free sub-items
  - [x] Curve and scheme base objects; quasi-coherent sheaves on schemes (tilde and
    its sections, basic opens, over-equivalences, module-cover conservativity).
  - [x] Relative Spec, projective morphisms, section rings; gluing, Zariski and
    Galois descent.
  - [x] Dual numbers and tangent spaces; Mumford's rigidity lemma; genus and the
    Abel--Jacobi interface.
- [x] **Line-bundle comparison isomorphisms** — `AJC.linebundle`, five sorry-free
  sub-items: coherence, pullback and the section formula, the tensor substrate, the
  dual comparison and terminal inverse, and the relative Picard group law.
- [x] **Grassmannian and graded substrate** — `AJC.grquot`, five sorry-free
  sub-items: Grassmannian cells and representability, section graded ring/module,
  graded Hilbert--Serre and the Hilbert polynomial, flattening stratification, and
  generic flatness.
- [~] **Cohomology and flat base change** *(3 open leaves)*
  - [x] The whole Čech engine — `AJC.cech`, six sorry-free sub-items: the
    combinatorial and section complexes with their contracting homotopy, the
    section-complex identification, affine acyclicity and acyclic resolutions,
    higher direct images with `pushPull` functoriality, Mayer--Vietoris, and the
    unconditional comparison theorem `cech_computes_higherDirectImage`.
  - [ ] Prove that flat pullback preserves finite limits *(1)*.
  - [ ] Prove the pushforward and twisted-nerve cosimplicial naturality laws *(2)*.
- [~] **Picard-scheme representability** *(6 open leaves)*
  - [x] Line bundles, the Grassmannian, graded modules, descent, and flattening are
    complete inputs.
  - [ ] Finish Serre finiteness and the Hilbert-polynomial package *(2)*.
  - [ ] Finish the Quot carrier and representability theorem *(3)*.
  - [ ] Assemble the relative Picard scheme *(1)*.
- [~] **`Pic^0` as an abelian variety** *(6 open leaves)*
  - [ ] Identify the degree-zero identity component *(3)*.
  - [ ] Complete the cotangent/`H^1` dimension comparison *(1)*.
  - [ ] Prove smoothness and properness *(2)*.
- [~] **Riemann--Roch and divisors** *(1 open leaf)*
  - [x] The adelic genus and cohomological finiteness lane is complete.
  - [ ] Prove that principal divisors have degree zero in `WeilDivisor` *(1)*.
- [~] **Albanese** *(7 open leaves)*
  - [ ] Finish the symmetric-power and universal-property assembly *(6)*.
  - [ ] Extend rational maps across codimension one *(1)*.
- [~] **Final Jacobian witness** *(1 open leaf)*
  - [ ] Assemble `picardJacobianWitness` from representability, the `Pic^0`
    abelian-variety structure, the dimension theorem, and Albanese universality.
- [~] **Maintenance and documentation**
  - [x] Optimize the Cech capstone and prune its unnecessary import chain.
  - [x] Record controlled-clean and warm full-project build and warning baselines.
  - [x] Normalize the copyright header of all 164 modules; restore the 1,123 blueprint
    statement titles that LaTeX was swallowing into the statement body.
  - [~] **Import hygiene — the dominant build cost.** 66 of 172 modules still open with a bare
    `import Mathlib` (down from 86; wave 2 landed at `3fbc2cace`), and every module in their
    transitive closure still loads the whole library. Measured: a 49-line module costs 16.6 s
    and ~7 GB with the umbrella and 3.5 s and 2.0 GB with four precise imports. The conversion
    runs bottom-up over the import DAG
    (`MainProjects/Algebraic-Jacobian-Challenge/scripts/deumbrella-wave.sh`). Deferred, not
    abandoned — a wave must repair its own cascade, since narrowing a parent breaks children
    that were inheriting `Mathlib` through it.
  - [ ] Retire the 179 heartbeat and 20 depth overrides. Mathlib itself has **zero**
    `set_option maxHeartbeats` in its library files; re-measure each with `#count_heartbeats in`
    once its module no longer imports the umbrella.
  - [ ] Drive the 138 mechanical Lean warnings to zero (24 `sorry` notices are honest and stay),
    and finish the blueprint prose, pin and print audits.

## Cech-Cohomology  *(✅ complete — deliverable merged sorry-free into AJC ✨ 2026-06-19; standalone fully green + sorry-free — the 16 v4.31-interim `sorry`s were closed and the full build (incl. the `CechToHigherDirectImage` capstone) verified 2026-07-03)*

**Goal:** `cech_computes_higherDirectImage` — for a separated quasi-compact `f : X ⟶ S`,
a quasi-coherent `F`, and a finite affine open cover, the cohomology of the relative Čech
complex computes `Rⁱf_* F`. Unconditional (no enough-injectives appeal).

- [x] **Combinatorial / free Čech engine** — alternating coface complex, homotopy contraction, exactness
- [x] **Section Čech complex & localization comparison** — `AwayComparison`, `phi/phiL` naturality
- [x] **Affine acyclicity (Serre vanishing)** — tilde-vanishing ⇒ affine Čech vanishing
- [x] **Cover/nerve combinatorics** — Čech nerve, wide pullbacks, `pushPull` sigma iso, finitary-extensive distributivity
- [x] **Quasi-coherence on opens** — over-equivalences, restrict-to-basic-open, modules-over-opens equivalence
- [x] **Higher direct image & acyclicity** — injective resolutions, horseshoe lemma, pushforward acyclicity
- [x] **PushPull functoriality** — `pushPullMap` composition, leg coherence, pentagon
- [x] **Comparison theorem `cech_computes_higherDirectImage`** *(proved iter-079, 0 sorries)*

## Line-Bundle-Comparison-Iso  *(✅ complete — sorry-free; deliverable merged → AJC)* ✨

**Goal:** the comparison-isomorphism substrate giving `Pic♯_{C/k}` its abelian-group
structure (the A.1.c.sub package; merged back into the Jacobian challenge).

- [x] **Stalk-tensor / internal-hom machinery** — `TensorObjSubstrate/StalkTensor`, `PresheafInternalHom`
- [x] **Slice-dual transport iso (DUAL route)** — `TensorObjSubstrate/DualInverse`, `DualInverse/SliceTransport`
- [x] **Line-bundle pullback / relative Pic functor** — `LineBundlePullback`, `RelPicFunctor`
- [x] **Terminal comparison inverse** — `TensorObjInverse` closed, including the keystone `trivialisation_restrict_compat` ✨

## Albanese  *(prover stage — extraction → Jacobian, 11 open `sorry`)* ✨

**Goal:** the Albanese universal property of `Pic⁰` (Milne III §6 Prop 6.1, seed
`thm:albanese_universal_property`) and the rational-map-extension machinery feeding the
abelian-variety leg of the Jacobian challenge. Extracted from `Algebraic-Jacobian-Challenge`
on 2026-06-20; merges back. *(Full `lake build` green — the carve had dropped load-bearing
base-scheme grading / `Over` / standard-smooth instances, restored from the parent ✨
2026-06-20.)*

- [x] **Auslander–Buchsbaum / coheight bridge** — `Albanese/AuslanderBuchsbaum`, `Albanese/CoheightBridge` **sorry-free**
- [x] **Rigidity lemma + structure-sheaf module substrate** — `RigidityLemma`, `Cohomology/StructureSheaf*` **sorry-free**
- [~] **Albanese universal property** — `Albanese/AlbaneseUP` (×7): the headline `Pic.albaneseUP` + universal-map descent
- [~] **Codim-one rational-map extension** — `Albanese/CodimOneExtension` (×1)
- [~] **FGA Picard representability slice** — `Picard/FGAPicRepresentability` (×2)
- [~] **Weil-divisor rider** — `RiemannRoch/WeilDivisor` (×1). The genus-0 / Route-C split is
  **retired** (2026-07-27): no `Genus0*` module, Lean identifier, blueprint node, or README
  reference survives in AJC; only two docstrings record it as a rejected route. `PrimeDivisor` /
  `order` were carved out and kept, per inbox `I-0106`, because codim-one depends on them.

## GR-Quot-Closure  *(✅ complete — sorry-free, deliverable merged → AJC ✨ 2026-06-22)*

**Goal:** representability of the relative Grassmannian — the Čech-independent (H⁰) leg that
builds `Grass(V, d)` from affine charts via the `GL_d` cocycle and proves it represents the
rank-`d`-quotient functor. **Merged back into `Algebraic-Jacobian-Challenge`** ✨ 2026-06-22.

- [x] **Grassmannian cells, gluing & descent** — `GrassmannianCells`, `GrassmannianQuot`, `GlueDescent`, `GradedHilbertSerre`, `RelativeSpec` *(now also in AJC)*
- [x] **Section graded ring (SNAP)** — `Picard/SectionGradedRing` through the graded ring and module stretch ✨ *(now also in AJC)*
- [x] **Quot scheme** — the file's quasi-coherent-descent machinery is sorry-free; the four χ-blocked endgame stubs (Hilbert polynomial, `QuotFunctor`, the `Grassmannian` functor def, `Grassmannian.representable`) were removed from this leg as out of its H⁰ scope and remain open in the AJC tree's own copy

## Picard-IdentityComponent  *(prover stage — 16 open `sorry`)*

**Goal:** the identity-component / `Pic⁰` group-scheme substrate (the A.3 leg), in
`Picard/IdentityComponent` (×9) and `Picard/FGAPicRepresentability` (×7). Roadmap node
`PIC.idcomp` is `blocked` pending the AJC representability inputs.

## MR0555258-Compactifying-Picard  *(prover stage — 1 open `sorry`)*

D'Souza's compactification of the Picard scheme, under
`SubProjects/RelatedPapersFormalisation/`; roadmap node `MR.pic`. Not on the
Jacobian-challenge critical path.
