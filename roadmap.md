# LeanAG — Scope Roadmap (condensed)

A high-level, mathematical checklist across the scope's member projects.

**Legend:**

- [x] proved / sorry-free (or, for a theme, its keystone declarations are sorry-free)
- [~] in progress (declarations exist, residual `sorry`)
- [ ] not started (no Lean yet — blueprint only, or theme not begun)

**Status snapshot** *(open `sorry` counts over each project's `AlgebraicJacobian/` source tree
via a Lean comment-stripping pass — comments/docstrings excluded; baseline measured 2026-06-30,
with separately dated rows refreshed later. The two active loops move these between pushes;
the **[live dashboard](https://axeldlv00.github.io/LeanAlgebraicGeometry/)**
holds the authoritative per-node counts. **v4.31 note (repaid 2026-07-03):** the mathlib
v4.31.0 bump had introduced ~20–30 mechanical **migration-interim** `sorry`s; all are now
closed — the AJC in-tree copies (T8, commit `eed5383`), the `GR-Quot-Closure` and
`Cech-Cohomology` standalones (back-ports, both verified green end-to-end), and
`MR0555258` (migrated v4.30.0→v4.31.0, first green build). No migration debt remains.):*

| Project | Stage | Open `sorry` |
| --- | --- | --- |
| Algebraic-Jacobian-Challenge-Rebuild | prover ✨ | 13 — all of them the protected `Challenge.lean` targets; **zero infrastructure sorries**. Wave 1 complete 2026-07-11 (see the rebuild section below) |
| Algebraic-Jacobian-Challenge | prover | 24 *(refreshed 2026-07-24; grouped by the nested AJC roadmap below)* |
| Cech-Cohomology | ✅ complete · merged → AJC | 0 — standalone green, v4.31-clean ✨ |
| Line-Bundle-Comparison-Iso | prover | 3 ✨ |
| Albanese | prover | 17 |
| Quot-Foundations | ⏸️ deferred | 21 |
| GR-quot_closure | ✅ complete · merged → AJC | 0 — standalone green, v4.31-clean ✨ |
| MR0555258-compactifying-picard | prover | 1 ✨ |
| 35 related-paper projects | 📝 blueprint only | 0 Lean (stub aggregators) |

---

## Dependency spine

### Core algebraic-geometry engine

- `Line-Bundle-Comparison-Iso` → `Algebraic-Jacobian-Challenge` (largest leverage: unblocks the Picard / comparison-iso substrate; merges back the `A.1.c.sub` package)
- `Albanese` → `Algebraic-Jacobian-Challenge` (extracted Albanese / abelian-variety leg — Albanese universal property, codim-one & Thm 3.2 rational-map extension, Auslander–Buchsbaum/coheight bridge; merges back) ✨ 2026-06-20
- `Cech-Cohomology` ↔ `Algebraic-Jacobian-Challenge` (the Čech `Rⁱf_*` engine is the cohomological substrate; proved sorry-free here, **merged sorry-free into the AJC tree** ✨ 2026-06-19 — all Čech MERGE-STUBs restored with the working proofs, AJC's full `lake build` is green and the capstone `cech_computes_higherDirectImage` is axiom-clean)
- `GR-quot_closure` → `Algebraic-Jacobian-Challenge` (Grassmannian-quotient representability H⁰ leg — `Grassmannian.represents`, SNAP section graded ring/module, cell-chart/glue-descent atlas; **merged sorry-free into the AJC tree** ✨ 2026-06-22 via a `union` merge, AJC `lake build` green) — originally extracted from `Quot-Foundations`
- `Quot-Foundations` → `Algebraic-Jacobian-Challenge` (the H⁰ Picard-representability cone — flat base change, Grassmannian, Quot — merges back; **deferred**, active work now lives in the `GR-quot_closure` extraction)

### Related papers → AG base

The 35 related-paper formalisations all depend on the core AG engine (schemes, cohomology,
curves, Picard) and are **blueprint-stage only**. Their per-paper `Requires` / `New infra`
breakdown, the shared-infrastructure vocabulary, coverage tiers, and the formalization-readiness
ordering now live in the dedicated **[Related-Papers roadmap](SubProjects/RelatedPapersFormalisation/roadmap.md)** ✨,
so this scope roadmap stays focused on the Jacobian-challenge critical path.

---

## Algebraic-Jacobian-Challenge-Rebuild  *(from-scratch rebuild — prover stage, 13 open `sorry` = exactly the protected `Challenge.lean` targets)* ✨

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
- [x] **Wave 2 item 6 — rigidity** ✨ — Mumford Form-I rigidity + Milne I 1.2 (pointed morphism
  of group schemes is a homomorphism), hypotheses weaker than Milne's.
- [~] **Wave 2 item 7 — χ-ledger / RR-lite** (next; twisted two-cover carrier landed as input)
- [~] **Wave 3 — Picard functor** (design spec in progress: cocycle `Ȟ¹(𝒪ˣ)` carrier,
  H_T-coset relative functor, pinned `RepresentableBy` datum; capability survey + old-draft
  post-mortem lessons committed in `informal/`)
- [ ] **Waves 4–7** — representability [RG], Pic⁰ abelian-variety package [RG], Albanese [RG],
  functorial layer (cheap by design given the pin)

Blueprint: Challenge/BaseChange/Curves/Algebra/Cohomology/AbelianVariety chapters all synced
1-to-1 with the Lean, `\leanok` only after kernel checks, `\source{}` read-before-cite.

## Algebraic-Jacobian-Challenge  *(core engine -- prover stage, 24 open `sorry` as of 2026-07-24)*

**Goal:** construct the Jacobian of a smooth proper geometrically integral curve as
`Pic^0`, prove that it is an abelian variety of dimension equal to the genus, and
establish the Albanese universal property. The structured roadmap command
`horizon roadmap list --focus AJC.jacobian` is the authoritative work breakdown.

- [x] **Foundational and representability substrate**
  - [x] Line-bundle coherence, pullback, tensor/dual comparison, and the relative
    Picard group law are sorry-free.
  - [x] The relative-Spec, Grassmannian, graded-algebra, glue-descent, flattening,
    and generic-flatness infrastructure is sorry-free.
- [~] **Cohomology and flat base change** *(3 open leaves)*
  - [x] The Cech higher-direct-image comparison and `pushPull` functoriality are
    sorry-free. Exact augmentations now supply the capstone comparison generically,
    without the former 4M-heartbeat specialized proof.
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
  - [ ] Continue bounded blueprint prose and formalization-pin audits.
  - [ ] Establish a fresh full-project build and warning baseline.

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

## Line-Bundle-Comparison-Iso  *(prover stage — extraction hub → Jacobian, 3 open `sorry`)* ✨

**Goal:** the comparison-isomorphism substrate giving `Pic♯_{C/k}` its abelian-group
structure (the A.1.c.sub package; merges back into the Jacobian challenge).

- [x] **Stalk-tensor / internal-hom machinery** — `TensorObjSubstrate/StalkTensor`, `PresheafInternalHom` **sorry-free**
- [x] **Slice-dual transport iso (DUAL route)** — `TensorObjSubstrate/DualInverse`, `DualInverse/SliceTransport` **sorry-free**
- [x] **Line-bundle pullback / relative Pic functor** — `LineBundlePullback`, `RelPicFunctor` **sorry-free**; seed `pullback_tensor_iso_loctriv` delivered ✨
- [x] **Bridge B2 terminal blocker** — `TensorObjInverse.restrictFunctorIsoPullback_comp_compat` is closed axiom-clean; `TensorObjInverse.lean` builds green with the blocker gone ✨
- [~] **Terminal comparison inverse** — **3 residual `sorry`**: the keystone `trivialisation_restrict_compat` (`TensorObjInverse`, iter-103 effort-broken into 3 seams), a dead-dup stub (`TensorObjSubstrate`), and one infrastructure `sorry` (`TrivialisationRestrict`) ✨

## Albanese  *(prover stage — extraction → Jacobian, 17 open `sorry`)* ✨

**Goal:** the Albanese universal property of `Pic⁰` (Milne III §6 Prop 6.1, seed
`thm:albanese_universal_property`) and the rational-map-extension machinery feeding the
abelian-variety leg of the Jacobian challenge. Extracted from `Algebraic-Jacobian-Challenge`
on 2026-06-20; merges back. *(Full `lake build` green — the carve had dropped load-bearing
`Genus0BaseObjects/BareScheme` grading / `Over` / standard-smooth instances, restored from
the parent ✨ 2026-06-20.)*

- [x] **Auslander–Buchsbaum / coheight bridge** — `Albanese/AuslanderBuchsbaum`, `Albanese/CoheightBridge` **sorry-free**
- [x] **Rigidity lemma + structure-sheaf module substrate** — `RigidityLemma`, `Cohomology/StructureSheaf*` **sorry-free**
- [~] **Albanese universal property** — `Albanese/AlbaneseUP` (×7): the headline `Pic.albaneseUP` + universal-map descent
- [~] **Codim-one & Thm 3.2 rational-map extension** — `Albanese/CodimOneExtension` (×3), `Albanese/Thm32RationalMapExtension` (×2)
- [~] **FGA Picard representability slice** — `Picard/FGAPicRepresentability` (×2)
- [~] **Genus-0 base + Weil-divisor riders** — `Genus0BaseObjects/BareScheme` (×1, `projectiveLineBar_geomIrred` scaffold), `Genus0BaseObjects/Points` (×1), `RiemannRoch/WeilDivisor` (×1)

## Quot-Foundations  *(⏸️ deferred — 21 open `sorry`; active work moved to subproject extractions)*

**Goal:** the Čech-independent (i = 0) leg of FGA Picard representability — flat base
change, generic flatness, and Quot/Grassmannian foundations. The Grassmannian-quotient
representability endgame is carved into the sibling extraction `GR-quot_closure` (below); the
flat-base-change leg is now pursued via the Čech route in AJC, and proofs merge back here.
**Deferred:** the directory is parked as `Quot-Foundations-[deferred_to_subprojects]` while
that extraction carries the active proving.

- [x] **Grassmannian construction & gluing** — `GrassmannianCells`, `GlueDescent` **sorry-free** (rank-quotient setoid, charts, transition cocycle, effective descent)
- [x] **RelativeSpec / flattening stratification** — `RelativeSpec`, `FlatteningStratification` **sorry-free**
- [x] **Graded Hilbert–Serre helper** — `GradedHilbertSerre`, `RegroupHelper` **sorry-free**
- [~] **Flat base change (degree 0)** — `Cohomology/FlatBaseChange` (×4), `FlatBaseChangeGlobal` (×1); pushforward Mayer–Vietoris / finite-generation criteria
- [~] **Tautological / universal quotient** — `GrassmannianQuot` (×3): `represents` done, `tautologicalQuotient_epi` closing
- [~] **Quot scheme** — `QuotScheme` (×4): `RepresentableBy` upgrade + Quot-representability core
- [~] **Section graded ring (SNAP)** — `Picard/SectionGradedRing` (×9): cast coherence → Hilbert polynomial *(shared with the sibling extractions)*

## GR-quot_closure  *(✅ complete — core deliverable merged sorry-free into AJC ✨ 2026-06-22; standalone fully green + sorry-free since 2026-07-03 — the v4.31 `SectionGradedRing` red build and the 3 interim `sorry`s are closed)*

**Goal:** representability of the relative Grassmannian — the Čech-independent (H⁰) leg that
builds `Grass(V, d)` from affine charts via the `GL_d` cocycle and proves it represents the
rank-`d`-quotient functor. Extracted from `Quot-Foundations`. **Merged back into
`Algebraic-Jacobian-Challenge` ✨ 2026-06-22** (union merge): the five sorry-free files +
`Grassmannian.represents` + the SNAP graded ring/module lane are now in the AJC tree, AJC
`lake build` green. *(The configured `enrich` scope was a no-op — all shared declarations
were identical or target-stronger — so the merge ran as a `union` to carry the real,
non-shared deliverable; three `Scheme.Modules.*` name collisions resolved by renaming the
imported copies.)*

- [x] **Grassmannian cells, gluing & descent** — `GrassmannianCells`, `GrassmannianQuot`, `GlueDescent`, `GradedHilbertSerre`, `RelativeSpec` **sorry-free** *(now also in AJC)*
- [x] **Section graded ring (SNAP)** — `Picard/SectionGradedRing` **sorry-free** through the graded ring and module stretch ✨ *(now also in AJC)*
- [x] **Quot scheme** — `QuotScheme` **sorry-free** ✨ *(2026-06-22)*: the four χ-blocked endgame stubs (`hilbertPolynomial`, `QuotFunctor`, the `Grassmannian` functor def, `Grassmannian.representable` — the Hilbert-polynomial/χ formulation, distinct from the proved `Grassmannian.represents`) were **removed** from this leg, since they need the cohomology / Euler-characteristic engine that is out of scope for the H⁰ Grassmannian deliverable; the file's sorry-free quasi-coherent-descent machinery is retained and `lake build` is green (8317 jobs). *(The same stubs still live in the AJC tree's own `Picard/QuotScheme` copy — see the AJC §"Picard representability cone" line — and remain open there.)*

---

## Related papers  *(📝 blueprint stage — moved to a dedicated roadmap ✨ 2026-06-30)*

The 35 related-paper projects now live in their own roadmap to keep this file readable:
**[SubProjects/RelatedPapersFormalisation/roadmap.md](SubProjects/RelatedPapersFormalisation/roadmap.md)**.

They are blueprint-only (Lean targets are stub aggregators, 0 real declarations) and do **not**
directly contribute to the Jacobian challenge. Five are formalization-ready *now* (`R0` —
`MR2223407` Picard scheme, `MR2223407` Hilbert/Quot, `MR3267585` cohomology & base change,
`MR1432198`, `MR1681097`); the readiness ordering (`R0`–`R3`) and full per-paper catalogue are
in that roadmap.
