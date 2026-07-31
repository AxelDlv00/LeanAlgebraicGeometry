# LeanAG — Scope Roadmap (condensed)

A high-level, mathematical checklist across the scope's member projects.

**Legend:**

- [x] proved / sorry-free (or, for a theme, its keystone declarations are sorry-free)
- [~] in progress (declarations exist, residual `sorry`)
- [ ] not started (no Lean yet — blueprint only, or theme not begun)

**Status snapshot** *(open `sorry` counts over each project's Lean source tree via a
comment-stripping pass — comments/docstrings excluded, and `scratch*`/`probe*` paths excluded for
the two main projects; measured 2026-07-31. The active loops move these between pushes; the
**[live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/)** holds the authoritative
per-node counts. All projects are on Lean/Mathlib `v4.31.0` with no migration debt.)*

| Project | Stage | Open `sorry` |
| --- | --- | --- |
| Algebraic-Jacobian-Challenge-Rebuild | prover ✨ | 16 in 2 of 824 library modules — 15 protected `Challenge.lean` targets, 1 in `Picard/Pic0ThetaCocycle.lean`. `Pic0ThetaCocycle` is imported from nowhere, so its theta coherence is unverified rather than proved; it is one of 18 root-unreachable modules (roadmap `AJCR.w4-rep.build-reach`, `AJCR.w7-functor.k1`). A further 60 `sorry` sit in tracked `scratch_*`/`ScratchPicC` dead-lane files that no build elaborates (inbox `I-1606`) |
| Algebraic-Jacobian-Challenge | prover | 31 in 13 of 374 modules, over a tree of **361** library modules / 191,855 lines; parallel lanes are live, so re-derive before quoting *(grouped by the nested AJC roadmap below)* |
| Cech-Cohomology | ✅ complete · merged → AJC | 0 |
| GR-Quot-Closure | ✅ complete · merged → AJC | 0 |
| Line-Bundle-Comparison-Iso | ✅ complete · merged → AJC | 0 |
| Albanese | prover | 12 |
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

## Algebraic-Jacobian-Challenge-Rebuild  *(from-scratch rebuild — prover stage, 16 open `sorry` in 2 of 824 library modules)* ✨

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
  is the authoritative breakdown — the gate is the DD-R certificate lane. Settled 2026-07-25:
  a certificate forces both pinned chart traces of the divisor closed, and the `Z(♦)` chart
  provably does *not* arrange that — the counterexample is field-independent. **Route decided
  2026-07-28 by binding human decision `I-0492`:** `DivFamZar` is widened to arbitrary affine
  open pieces (R2). The `Aut(ℙ¹)`/`GL₂` coordinate-twist route (R1) is **not** to be built —
  leaf `…certificate.p1-aut` stays pending and deprioritised, and no consumer may be written
  against it. The small-finite-field question of `I-0346` is closed by the same decision. The R2
  widening is **built and sorry-free** as of 2026-07-28, now in 48 `Picard/DivisorFamilyAff*.lean`
  files (23 on the first day); the widened carrier has both its `mapAlg` and
  `mapAlgHom` faces and a vehicle, but the migration has barely moved — re-measured 2026-07-31:
  **69** files still consume the old chart-typed `DivFamZar`, and of the 21 that mention
  `DivFamZarAff` only **one** (`Picard/Pic0ChartHonestAff.lean`) is outside the
  `DivisorFamilyAff*` cone, per inbox `I-0506` and `I-0617`.)
- [~] **Waves 5–7** — Pic⁰ abelian-variety package, Abel–Jacobi / Albanese, functoriality and
  base change of fields (each partly landed; see the structured roadmap)

Blueprint: Challenge/BaseChange/Curves/Algebra/Cohomology/AbelianVariety chapters all synced
1-to-1 with the Lean, `\leanok` only after kernel checks, `\source{}` read-before-cite.

## Algebraic-Jacobian-Challenge  *(core engine — prover stage, 31 open `sorry` in 13 of 374 modules)*

**Goal:** construct the Jacobian of a smooth proper geometrically integral curve as
`Pic^0`, prove that it is an abelian variety of dimension equal to the genus, and
establish the Albanese universal property. The structured roadmap command
`horizon roadmap list --focus AJC.jacobian` is the authoritative work breakdown.

*Re-measured 2026-07-31 (comment-stripped, `scratch*`/`probe*` excluded): 361 of 374 counted
paths are sorry-free, with all 31 remaining `sorry`s in 13 — the largest groups
`Albanese/AlbaneseUP` (6), `Jacobian` (4), `Cohomology/CechHigherDirectImageUnconditional` (3),
`Picard/Pic0AbelianVariety` (3). Both halves of this ratio drift hourly under parallel lanes.
Re-derive with
`lake build AlgebraicJacobian 2>&1 | grep 'declaration uses' | sort -u`
rather than quoting these.*

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
- [~] **Cohomology and flat base change** *(1 open leaf + 1 bypassed monument)*
  - [x] The whole Čech engine — `AJC.cech`, six sorry-free sub-items: the
    combinatorial and section complexes with their contracting homotopy, the
    section-complex identification, affine acyclicity and acyclic resolutions,
    higher direct images with `pushPull` functoriality, Mayer--Vietoris, and the
    unconditional comparison theorem `cech_computes_higherDirectImage`.
  - [x] The pushforward cosimplicial naturality law — closed run 0068 r3
    (`cech_pushforward_baseChange_natIso_flat`); the per-σ mate was already the
    project's own `canonicalBaseChangeMap_isIso`.
  - [ ] Prove the twisted-nerve cosimplicial naturality law *(1)* — the sole
    obstruction; endpoint `cech_flatBaseChange_oneLeaf`.
  - [~] Flat pullback preserves finite limits — bypassed on quasi-coherent objects
    (`pullback_preservesKernel_of_isQuasicoherent`); the arbitrary-module mono
    statement is kept as a monument, deliberately unproved.
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
- [x] **Riemann--Roch and divisors** — complete.
  - [x] The adelic genus and cohomological finiteness lane is complete.
  - [x] Principal divisors have degree zero (`WeilDivisor.principal_degree_zero`, proved
    through the ported χ-ledger in `RiemannRoch/Ledger/`; roadmap `AJC.rr.principal` is
    `done` and the module is sorry-free on a comment-stripped census).
- [~] **Albanese** *(6 open leaves, all in one module)*
  - [x] Extend rational maps across codimension one — Milne Lemma 3.3 and the Thm 3.2
    extension are proved and axiom-clean; `Albanese/CodimOneExtension` is **sorry-free**
    (run 0069, `8a5dc2a66`). Any note citing sorries there is quoting docstring prose.
  - [ ] Finish the symmetric-power and universal-property assembly *(6, all in
    `Albanese/AlbaneseUP`)*. Stated against the `sorry`-bodied `SymmetricPower`, so they are
    undischargeable as stated until `HasColimit (permDiagram C g)` lands; the mathematics
    itself is proved over the symmetric power as an interface in `Albanese/AlbaneseFromData`.
- [~] **Final Jacobian witness.** `picardJacobianWitness` is built and wired — the witness *is*
  `Scheme.Pic0Scheme` — so what remains is mathematics, not assembly. **Decided 2026-07-28 by
  binding human decision `I-0491`:** the headline is stated over an arbitrary field with no
  rational-point binder, via the étale-sheafified Picard functor. `hasRationalPoint_of_curve` was
  false as stated and is deleted, not proved; it survives only as the theorem
  `hasRationalPoint_of_curve_of_isAlgClosed` over an algebraically closed field. Five obligations
  remain, and the witness carries `sorryAx` until all five land: étale representability
  (`fgaPicardRepresentability`), `Pic0Et.geometricallyReduced`, `Pic0Et.universallyClosed`,
  the smooth-relative-dimension leaf, and the Albanese leaf.
- [~] **Maintenance and documentation**
  - [x] Optimize the Cech capstone and prune its unnecessary import chain.
  - [x] Record controlled-clean and warm full-project build and warning baselines.
  - [x] Normalize the copyright header of every module (164 at the time); restore the 1,123 blueprint
    statement titles that LaTeX was swallowing into the statement body.
  - [~] **Import hygiene — the dominant build cost.** 115 of 361 modules still open with a bare
    `import Mathlib` (re-measured 2026-07-31; wave 2 landed at `3fbc2cace`), and every module in their
    transitive closure still loads the whole library. Measured: a 49-line module costs 16.6 s
    and ~7 GB with the umbrella and 3.5 s and 2.0 GB with four precise imports. The conversion
    runs bottom-up over the import DAG
    (`MainProjects/Algebraic-Jacobian-Challenge/scripts/deumbrella-wave.sh`). Deferred, not
    abandoned — a wave must repair its own cascade, since narrowing a parent breaks children
    that were inheriting `Mathlib` through it.
  - [ ] Retire the 248 heartbeat overrides (190 `maxHeartbeats`, 58 `synthInstance*`, re-measured
    2026-07-31 — up from 200) and the depth
    overrides. Mathlib itself has **zero**
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

## Albanese  *(prover stage — extraction → Jacobian, 12 open `sorry`)* ✨

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
- [~] **Residual genus-0 module in this subproject** — `Genus0BaseObjects/GmScaling` (×1). The
  retirement above was scoped to AJC; this extraction still carries the module. Retire or root it
  when the Albanese leg next merges back.

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
