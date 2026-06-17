# Blueprint Reviewer Directive

## Slug
iter189

## Strategy snapshot

Goal: formalize Christian Merten's Jacobian challenge — 9 protected
declarations headlined by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness`. End-state: zero inline `sorry`,
kernel-only axioms. Char-general: `[Field k]` only.

Spine: **pointed vs. unpointed**. `genus C := dim_k H^1(C, O_C)`
(arithmetic genus; protected).

### Phases & estimations (current STRATEGY.md table)

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| A.1.a — RelativeSpec | functionally complete; signature refinement separately tracked | ~5-10 | ~80-150 · ~0/it | qcoh-algebras → schemes | signature drift |
| A.1.b — LineBundle.Pullback | **SOLVED iter-188** (full file 0 sorries axiom-clean) | DONE | DONE | — | — |
| A.1.c — RelPic functor | skeleton landed; body gated | ~10-17 | ~300-500 · gated | ét-sheafification | gated on A.1.b |
| A.2.a.i — Generic flatness | chapter landed | ~16-28 | ~500-800 · gated | Stacks 052H pieces | unowned Mathlib gap |
| A.2.a.ii — Noetherian induction | chapter landed | ~24-42 | ~800-1300 · gated | noetherian induction | iterates on A.2.a.i |
| A.2.a.iii — Stratum-glueing | chapter landed | ~20-44 | ~700-1400 · gated | gluing along stratification | assembly |
| A.2.b.i — Grassmannian scheme | chapter landed | ~18-36 | ~600-1100 · gated | Plücker; projective embedding | absent from Mathlib |
| A.2.b.ii — Flat-locus open subscheme | chapter landed | ~24-48 | ~800-1500 · gated | flat-locus openness; descent | builds on A.1.a + A.2.a.i |
| A.2.b.iii — Quot assembly | chapter landed | ~36-72 | ~1200-2400 · gated | Quot via Hilbert | bundles A.2.b.i + ii + A.2.a |
| A.2.c — FGA Pic_{C/k} assembly | skeleton landed; body gated | ~12-16 | ~600-800 · gated | wires Quot + RelPic | small assembly |
| A.3.i — GroupScheme.IdentityComponent | 2 closures + 5 pinned scaffolds; EGA I 6.1.9 closed iter-188 axiom-clean | ~4-8 | ~150-300 · ~30/it | `LocallyConnectedSpace` from `IsLocallyNoetherian` (NEW; landed); `IsOpenSubgroupScheme` | EGA I 6.1.9 closed |
| A.3.ii — Pic⁰_{C/k} definition | **NO BLUEPRINT YET — unstarted-phase** | ~2-4 | ~80-200 · gated | `(PicScheme C).IdentityComponent` | small assembly |
| A.3.iii — tangent space iso H¹(O_C) ≅ T_0 Pic⁰ | **NO BLUEPRINT YET** | ~6-10 | ~200-400 · gated | deformation theory; cotangent complex at identity | requires A.3.ii body |
| A.3.iv — Pic⁰ smoothness of relative dim g | **NO BLUEPRINT YET** | ~8-12 | ~300-500 · gated | local criterion via H¹(O_C); A.3.iii | requires A.3.iii |
| A.3.v — Pic⁰ properness | **NO BLUEPRINT YET** | ~6-10 | ~250-400 · gated | Pic^d-translate; valuative criterion | requires A.3.ii |
| A.3.vi — Pic⁰ geometrically irreducible | **NO BLUEPRINT YET** | ~4-8 | ~150-300 · gated | geom-connectedness; reduce to k̄ | requires A.3.ii |
| A.3.vii — degree map Pic → ℤ | skeleton landed; body gated | ~2-4 | ~80-200 · gated | degree of line bundle on curve | small assembly |
| A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface API | skeleton landed; body gated | ~40-80 | ~1500-2500 · gated | codim-1 indeterminacy; valuative criterion | dominant Route-A risk |
| A.4.b — Auslander–Buchsbaum import | G1 cotangent dim drop substrate **CLOSED iter-188**; G2 joint induction next | ~10-18 | ~280-360 · gated | Stacks 00NQ joint induction | Mathlib gap; ~300 LOC |
| A.4.c.0 — codim-≥2 conclusion of Milne 3.1 | sub-helper exposure owed | ~2-4 | ~80-200 · gated | codim-≥2 extraction | bundled inside A.4.a body |
| A.4.c.1 — Thm 3.2 assembly | helper split landed; conjunction wrapper kernel-clean | ~8-14 | ~400-700 · gated | bundles A.4.a + A.4.b + A.4.c.0 | needs A.4.c.0 |
| A.4.d (divisor-map Albanese UP) | **CHAPTER REWRITE PENDING this iter** (pivot from Sym^g per iter-188 strategy decision) | ~10-18 | ~400-800 · gated | universal effective divisor → Pic^d morphism + degree-g translate | replaces Sym^g/S_g-quotient gap |
| Genus-0 rigidity — chart-bridge (III.c separated-locus) | iter-188 BLOCKED on falsified Mathlib substrate (`IsClosedImmersion.lift_iff_range_subset` NOT in Mathlib at b80f227) | USER ESCALATION → planner Option B committed | ~150-200 substrate · gated | project-side `lift_iff_range_subset` + tensor-of-domains | substrate iterates |
| Genus-0 rigidity — chart-bridge collapse-at-zero body | honest sorry | ~2-4 | ~30-70 · NOT-YET-MEASURED | chart-1 ring-map identity at u=0 | cover-glue chase |
| Genus-0 RR.1 — Weil divisors | active body | ~4-8 | ~150-350 · ~30/it | divisors; closed-point order; degree map | parallel-startable |
| Genus-0 RR.2.H⁰ — H⁰ half of χ-skyscraper | **CLOSED iter-188 axiom-clean** | DONE | DONE | — | — |
| Genus-0 RR.2.H¹ — skyscraper-flasque vanishing (project-side) | committed; new typed sorry helper landed iter-188 | ~8-12 | ~200-400 · gated | flasque sheaves; H¹ vanishing of flasque on noetherian | NEW (H¹ on critical path via genus def) |
| Genus-0 RR.2 assembly — χ-additivity + LES | bundles H⁰ + H¹ halves | ~4-8 | ~150-300 · gated | LES-of-Ext; 6-term alternating-rank identity | gated on RR.2.H⁰ + H¹ |
| Genus-0 RR.3 — O_C(P) global sections | carrier refactor in progress (Subfunctor restructure planned iter-189) | ~10-20 | ~200-400 · ~30/it | invertible sheaf at point; restriction sequence | extracts non-constant function |
| Genus-0 RR.4 — rational ⟹ ≅ ℙ¹ | localParameterAtInfty **CLOSED iter-188**; `Hom.poleDivisor_degree_eq_finrank` body iter-189 target | ~6-10 | ~300-500 · gated | `Proj.fromOfGlobalSections`; degree-1 iso | finishes the bridge |
| `genusZeroWitness` body + `k̄→k` descent | gated on rigidity + RR bridge | ~7-10 | ~350-850 · gated | terminal cluster on Spec k; faithfully-flat descent | descent LOCKED Spec-k-direct |
| `nonempty_jacobianWitness` body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

- Route A (Picard scheme via FGA): positive-genus arm. `J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6.
- Route C (Milne §I.3 rigidity): genus-0 arm. `J = Spec k` trivial.

## References

- `references/challenge.lean.ref` — protected signatures of Merten's challenge.
- `references/kleiman-picard.md` → `kleiman-picard.pdf` / `-src/` — Pic scheme construction.
- `references/nitsure-hilbert-quot.md` → `nitsure-hilbert-quot.pdf` / `-src/` — Quot/Hilbert engine.
- `references/abelian-varieties.md` → `abelian-varieties.pdf` — Milne course notes (Rigidity Thm 1.1; Thm 3.2/Prop 3.10; AlbaneseUP Prop 6.1/6.4).
- `references/mumford-abelian-varieties.md` → `mumford-abelian-varieties.pdf` — Mumford AV.
- `references/stacks-*.md` — Stacks Project chapters (Varieties, Fields, Algebra, Coherent, Constructions).

## Focus areas

1. **Iter-188 prover phase added NEW pinned declarations** — please re-verify pin pointers for all newly named typed-sorry helpers:
   - `Picard/QuotScheme.lean`: NEW `pullback_app_isoTensor_baseMap_sectionLinearEquiv` (Σ-pair packaging).
   - `RiemannRoch/RRFormula.lean`: NEW `H0_skyscraperSheaf_finrank_eq_one` + `H1_skyscraperSheaf_finrank_eq_zero` (RR.2.H⁰ closed; H¹ new typed sorry on the committed RR.2.H¹ sub-phase).
   - `RiemannRoch/OCofP.lean`: NEW `carrierSubmoduleSheaf` wrapper (`carrierSubmodule ⊓ trivAtBot`) — structural carrier refactor.
   - `Picard/IdentityComponent.lean`: NEW `identityComponent_locallyConnectedSpace` (private; EGA I 6.1.9 helper) — axiom-clean closure.
2. **iter-188 plan-phase pin additions on `Picard_LineBundlePullback.tex` (SF-1: `def:IsLocallyTrivial` + `lem:IsLocallyTrivial_pullback`) + `Picard_QuotScheme.tex` (SF-2: `lem:pullback_tildeIso` + `lem:pushforward_isQuasicoherent`)** — verify these are accurate against the iter-188 prover landings (`IsLocallyTrivial` predicate + `IsLocallyTrivial.pullback` are both now axiom-clean iter-188).
3. **III.c substrate falsification in `AbelianVarietyRigidity.tex`** — iter-188 review added `% NOTE` flagging `IsClosedImmersion.lift_iff_range_subset` NOT in Mathlib at b80f227. Verify the chapter prose is internally consistent with the corrective path (project-side substrate Option B).
4. **A.3.ii–vi unstarted phases** — `Picard_Pic0AbelianVariety.tex` was proposed iter-188 reviewer but not yet written. Produce a concrete chapter outline proposal for iter-189 writer dispatch.
5. **A.4.d Sym^g → divisor-map pivot** — `Albanese_AlbaneseUP.tex` chapter currently describes Sym^g UP route. Per iter-188 strategy decision, must be rewritten for divisor-map Albanese UP. Confirm the chapter's current state and recommend whether full rewrite (in place) or new chapter (sibling) is preferable.
6. **RR.2.H¹ unstarted phase** — committed sub-phase per iter-188 STRATEGY revision; no dedicated chapter yet. Surface as unstarted-phase proposal.

## Known issues

- Lane M↓ Option (c) committed: `CodimOneExtension.lean` declared COMPLETE-EXCEPT-UPSTREAM-GAP per iter-188 plan-phase. The narrow `isRegularLocalRing_stalk_of_smooth` named sorry is accepted as permanent until Mathlib upstreams `Smooth → IsRegularLocalRing`. Don't re-flag.
- Lane J `OcOfD.lean`: structurally BLOCKED iter-187; do not flag for prover work.
- `BareScheme.lean` 2 sorries: Mathlib gaps; off-target.
