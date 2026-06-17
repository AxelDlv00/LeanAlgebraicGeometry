# Blueprint Reviewer Directive

## Slug
iter188

## Strategy snapshot

Project goal: formalize Christian Merten's Jacobian challenge
(`references/challenge.lean`): nine protected declarations headlined
by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness`
— existence of an Albanese / Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible
curve `C / k`, with NO `C(k) ≠ ∅` hypothesis. End-state: zero inline
`sorry`, kernel-only axioms. **Char-general:** the protected
signatures take `[Field k]` only — NO `CharZero`.

Spine: **pointed vs. unpointed**. `genus C := \dim_k H^1(C, O_C)`
(arithmetic genus; protected).

### Phases & estimations (full table — needed for unstarted-phase proposals)

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| **A.1.a — `RelativeSpec`** | 5-helper structured proof landed iter-183; 2 narrowly-scoped Tier-3 sorries remain; STUCK + OVER_BUDGET | ~20–30 | ~100–250 · ~0/it | qcoh-algebras → schemes; `IsAffineOpen.map_fromSpec`; transparency unfolds | iter-185 HARD BAR test mandatory |
| **A.1.b — `LineBundle.Pullback`** | iter-186 5 → 0 axiom-clean on first body attempt; iter-187 IsLocallyTrivial subtype refinement, 0 → 1 named sorry | ~2–4 | ~200–400 · ~50/it | line-bundle pullback; sheafification; chart-iso | small once A.1.a body lands |
| **A.1.c — `RelPic functor`** | skeleton landed; body gated | ~10–17 | ~300–500 · ~30/it | ét-sheafification; presheaf functoriality | gated on A.1.a real body |
| **A.2.a.i — Generic flatness** | chapter landed | ~16–28 | ~500–800 · gated | Stacks 052H pieces; generic flatness | unowned Mathlib gap |
| **A.2.a.ii — Noetherian induction over strata** | chapter landed | ~24–42 | ~800–1300 · gated | noetherian induction | iterates on A.2.a.i |
| **A.2.a.iii — Stratum-glueing & functoriality** | chapter landed | ~20–44 | ~700–1400 · gated | gluing along finite stratification | assembly |
| **A.2.b.i — Grassmannian scheme** | chapter landed | ~18–36 | ~600–1100 · gated | Plücker; projective embedding | absent from Mathlib |
| **A.2.b.ii — Flat-locus open subscheme** | chapter landed | ~24–48 | ~800–1500 · gated | flat-locus openness; descent | builds on A.1.a + A.2.a.i |
| **A.2.b.iii — Quot assembly** | chapter landed | ~36–72 | ~1200–2400 · gated | Quot via Hilbert | bundles A.2.b.i + ii + A.2.a |
| **A.2.c — FGA `Pic_{C/k}` assembly** | skeleton landed; body gated | ~12–16 | ~600–800 · gated | wires Quot + RelPic | small assembly |
| **A.3 — `Pic⁰` identity + degree** | chapter landed iter-186 Path B split; iter-187 IdentityComponent.lean 2 closures + 5 new pinned scaffolds | ~16–28 | ~600–900 · gated | `GroupScheme.IdentityComponent`; EGA I 6.1.9 `LocallyConnectedSpace` substrate (NEW PROJECT MATERIAL) | substrate not in Mathlib |
| **A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface API** | skeleton landed; body gated | ~40–80 | ~1500–2500 · gated | codim-1 indeterminacy; Weil-divisor surface; valuative criterion | dominant Route-A risk |
| **A.4.b — Auslander–Buchsbaum import** | sub-lane G1 cotangent dim drop substrate landed iter-187; G2 joint induction iter-188+ | ~10–18 | ~280–360 · gated | depth, projective dimension; Stacks 00NQ joint induction | Mathlib gap; ~300 LOC across 2-3 iters |
| **A.4.c.0 — codim-≥2 conclusion of Milne 3.1 as standalone Lean lemma** | sub-helper exposure owed | ~2–4 | ~80–200 · gated on A.4.a | codim-≥2 extraction | bundled inside A.4.a body |
| **A.4.c.1 — Thm 3.2 assembly** | helper split landed; conjunction wrapper kernel-clean | ~8–14 | ~400–700 · gated | bundles A.4.a + A.4.b + A.4.c.0 | needs A.4.c.0 |
| **A.4.d.i — `Sym^g C` sub-build** | chapter landed; substrate unowned | ~10–18 | ~400–700 · gated | `S_g`-quotient; smoothness/properness | new project material |
| **A.4.d.ii — Albanese UP wiring** | skeleton landed; body gated | ~6–10 | ~200–400 · gated | uses A.4.d.i + A.3 + A.4.c | small assembly |
| **Genus-0 rigidity — chart-bridge cross-case body** | STUCK + OVER_BUDGET (5 elapsed vs ~2-4 est); iter-187 plan commits to (III.c) separated-locus alternative; iter-187 writer landed expanded recipe | ~3–5 | ~80–120 · gated | `IsSeparated.diagonal_isClosedImmersion` + `prod.lift` + `IsClosedImmersion.lift` (all present at b80f227) | category-theory chase via diagonal closed-immersion factorization |
| **Genus-0 rigidity — chart-bridge collapse-at-zero body** | honest sorry | ~2–4 | ~30–70 · NOT-YET-MEASURED | chart-1 ring-map identity at `u=0` | cover-glue chase |
| **Genus-0 RR.1 — Weil divisors** | active body | ~4–8 | ~150–350 · ~30/it | divisors; closed-point order; degree map | parallel-startable |
| **Genus-0 RR.2 — RR formula for genus 0** | iter-187 blueprint-writer split H⁰ half (axiom-clean closable iter-187+) from H¹ half (Mathlib gap — flasque cohomology) | ~6–14 | ~400–600 · gated | LES-of-Ext carrier; H¹ flasque vanishing | H¹ half indefinitely gated until Mathlib upstream |
| **Genus-0 RR.3 — `O_C(P)` global sections** | iter-187 carrierSubmodule cascade closures axiom-clean (3 of 7 sorries closed); CHURNING → CONVERGING transition | ~20–30 | ~400–600 · ~0/it | invertible sheaf at point; restriction sequence | extracts non-constant function |
| **Genus-0 RR.4 — rational ⟹ `≅ ℙ¹`** | iter-187 `Hom.poleDivisor` body substantive via `[Algebra K(ℙ¹) K(C)]` typeclass binder; STUCK → CONVERGING | ~8–12 | ~400–600 · gated | `Proj.fromOfGlobalSections`; degree-1 iso | finishes the bridge |
| `genusZeroWitness` body + `k̄→k` descent | gated on rigidity + RR bridge | ~7–10 | ~350–850 · gated | terminal cluster on Spec k; faithfully-flat descent | descent LOCKED Spec-k-direct |
| `nonempty_jacobianWitness` body | gated on both arms | 1 | <50 · gated | `by_cases h : genus C = 0` | trivial once both arms close |

## Routes

- **Route A — Picard scheme via FGA** (positive-genus arm; mandatory):
  `J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6.
  A.2 + A.4 decomposed per table. A.4.a = dominant risk; A.4.b
  independently startable. Chapters covering this route:
  `Picard_RelativeSpec.tex`, `Picard_LineBundlePullback.tex`,
  `Picard_RelPicFunctor.tex`, `Picard_FlatteningStratification.tex`,
  `Picard_QuotScheme.tex`, `Picard_FGAPicRepresentability.tex`,
  `Picard_IdentityComponent.tex`, `Albanese_CodimOneExtension.tex`,
  `Albanese_AuslanderBuchsbaum.tex`, `Albanese_Thm32RationalMapExtension.tex`,
  `Albanese_AlbaneseUP.tex` (+ Albanese_SymmetricPower owed).
- **Route C — genus-0 rigidity via Milne §I.3**:
  `J = Spec k` trivial. Over `k̄`, every pointed `f : C → A` is constant.
  Genus-0 ⟹ ℙ¹ via RR bridge. Chapters: `AbelianVarietyRigidity.tex`,
  `RiemannRoch_RRFormula.tex`, `RiemannRoch_OCofP.tex`,
  `RiemannRoch_WeilDivisor.tex`, `RiemannRoch_RationalCurveIso.tex`,
  `RiemannRoch_OcOfD.tex`, `RigidityKbar.tex`, `Rigidity.tex`,
  `Genus.tex`, `Jacobian.tex`, `AbelJacobi.tex`.

## References

- `references/challenge.lean` — original challenge signatures.
- `references/abelian-varieties.md` → `references/abelian-varieties.pdf`
  (Milne §I.1 Rigidity, §I.3 Thm 3.2, §I.5 cube, §III.6 Albanese UP).
- `references/mumford-abelian-varieties.md` → `mumford-abelian-varieties.pdf`.
- `references/kleiman-picard.md` → `kleiman-picard.pdf` (Picard scheme).
- `references/nitsure-hilbert-quot.md` → `nitsure-hilbert-quot.pdf`.
- `references/hartshorne-algebraic-geometry.md` → `hartshorne-algebraic-geometry.pdf`
  (RR formula IV.1; Section II.6 Cartier divisors; Section III.2 cohomology).
- `references/stacks-{algebra,coherent,constructions,fields,varieties}.tex`.

## Focus areas (this iter)

iter-187 plan-phase landed two blueprint-writer dispatches addressing
iter-187 must-fix items; please re-confirm on the HARD GATE:

1. **`blueprint/src/chapters/RiemannRoch_RRFormula.tex`** — writer
   `rrformula-h0h1split` added 3 substrate-lemma blocks
   (`lem:euler_char_shortExact_add`, `lem:euler_char_iso`,
   `lem:euler_char_skyscraperSheaf`) + H⁰/H¹ split. Lane H depends on
   this clearance.
2. **`blueprint/src/chapters/AbelianVarietyRigidity.tex`** — writer
   `avr-iiic-pivot-label` relabeled (III.a) BLOCKED + (III.b) DESCOPED
   + (III.c) MANDATORY PIVOT in
   `lem:gmscaling_chart_agreement`; expanded (III.c) recipe with the
   diagonal closed-immersion factorization. Lane B + Lane E both depend
   on this clearance.

Other prover-lane chapters to confirm PASS:

- `RiemannRoch_OCofP.tex` (Lane A continues; 4 sorries remaining; 3
  closures iter-187 axiom-clean; refactor pins for `carrierPresheaf` /
  `carrierPresheaf_isSheaf` landed iter-187 plan-phase).
- `Picard_LineBundlePullback.tex` (Lane A.1.b; 1 named sorry on
  `IsLocallyTrivial.pullback`; iter-187 review noted `IsLocallyTrivial`
  + `IsLocallyTrivial.pullback` not yet pinned in chapter — soft
  finding).
- `Picard_QuotScheme.tex` (Lane F; 11 sorries; 2 new named typed
  sorries `pullback_tildeIso` Stacks 01HQ + `pushforward_isQuasicoherent`
  Stacks 01XJ — pins not yet in chapter; iter-187 review SF-9 owed).
- `Picard_IdentityComponent.tex` (Lane IdentityComponent; 9 sorries
  including 5 new pins added iter-186 plan-phase Path B split that all
  landed as Lean declarations iter-187).
- `Albanese_AuslanderBuchsbaum.tex` (Lane G; G1 cotangent dim drop
  substrate landed; 3 sorries; chapter PASS at iter-187 reviewer).
- `Albanese_CodimOneExtension.tex` (Lane M↓; 3 sorries; chapter PASS
  at iter-187 reviewer; new named typed sorry
  `isRegularLocalRing_stalk_of_smooth` captures Stacks 00TT gap).
- `RiemannRoch_RationalCurveIso.tex` (Lane I; 3 sorries; `Hom.poleDivisor`
  body substantive via `[Algebra K(ℙ¹) K(C)]` binder; 1 narrow named
  typed sorry on `localParameterAtInfty` substrate).
- `RiemannRoch_OcOfD.tex` (Lane J; 3 sorries; iter-187 finding:
  `sheafOf_zero` axiom-cleanness structurally blocked by `sheafOf`
  body's `else sorry`; chapter currently PASS but may need
  strategy-mod note if Lane J is officially deferred).

## Known issues

- 5 new chapter-pin declarations on `Picard_IdentityComponent.tex`
  (`isSubgroupHomomorphism`, `isFiniteTypeGeometricallyIrreducible`,
  `baseChangeIso`, `finrank_eq_genus`, `kPoints_iff_kerDegree`) — these
  all landed as Lean declarations iter-187; the chapter pins were added
  iter-186 plan-phase Path B split. Please confirm they're well-formulated.
- `Picard_LineBundlePullback.tex` may need 2 new chapter pins for
  `IsLocallyTrivial` + `IsLocallyTrivial.pullback` (iter-187 prover
  recommendation). If so, this is a soft finding — plan agent can land
  iter-188 plan-phase.
- `Picard_QuotScheme.tex` may need 2 new chapter pins for
  `pullback_tildeIso` + `pushforward_isQuasicoherent` (iter-187 analogist
  / prover recommendation). Same as above.
- `Picard_IdentityComponent.tex` `identityComponent_locallyConnectedSpace`
  helper — is this pinned in the chapter? The relocation moved a Mathlib
  gap (EGA I 6.1.9) into a focused helper.
- `RiemannRoch_OcOfD.tex` may need a `% NOTE` on the structural
  blocking of `sheafOf_zero` axiom-cleanness pending `sheafOf` body
  off-target work.

## Out of scope

`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane B) and
`AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane E) — Lane B/E
prover work was deferred iter-187 precisely because chapter
`AbelianVarietyRigidity.tex` was MF-2 PARTIAL. The clearance of that
chapter via the writer fix is the SOLE GATE; if PASS, Lane B + Lane E
proceed iter-188.

Similarly `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (Lane H) is
gated on `RiemannRoch_RRFormula.tex` PASS.
