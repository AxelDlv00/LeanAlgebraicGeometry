# Strategy-critic directive — iter-208 (slug clean208)

You are a fresh-context critic of the project's global strategy. Read ONLY what
is in this directive. Do NOT read PROGRESS.md, iter sidecars, task results, or
prover narrative. Judge the strategy as a fresh mathematician would.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected Lean
declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over
the k-rational pointing of a smooth proper geometrically irreducible curve C/k,
with NO `C(k)≠∅` hypothesis and NO `CharZero` (only `[Field k]`). The witness
`J := Pic⁰_{C/k}` is built unconditionally; only `isAlbaneseFor` is quantified
over the pointing.

## What changed this iter (for your re-verification)

Two strategic decisions were made this iter, each backed by a fresh
reference-reading consult:
1. Lane A.1.c.SubT's hard iso `tensorObj_restrict_iso` re-routed from the
   (4-iter-dead) abstract-adjoint mate-δ route to "Route A" (open-immersion
   sectionwise base change along the structure-sheaf ring iso).
2. Albanese UP committed to "Route 2" (Kleiman `rmk:Alb` from representability +
   RR-free autoduality), and the "Route 1" Milne-Thm-3.2 codim cone (incl. the
   27-iter-stuck Stacks-02JK node) declared EXCISED as dead substrate.
Challenge these if the strategy as written does not support them.

## Current STRATEGY.md (verbatim)

```markdown
# Strategy

## Goal

Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`):
the nine protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the
`k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`, with
**no** `C(k)≠∅` hypothesis and **no** `CharZero` (only `[Field k]`). The witness `J`
is built unconditionally; only `isAlbaneseFor` is quantified over the pointing.
Spine: **pointed vs. unpointed**; `J := Pic⁰_{C/k}`.

**Posture:** option (c) holding pattern — forward Route-A substrate while the
Riemann–Roch substrate stays frozen by the USER ROUTE C PAUSE. No protected decl yet
closes with a kernel-only `#print axioms`. Representability (A.2.c) is RR-free; the
current `Pic⁰ := degComp` witness still transits RR at its degree identification (a
fully RR-free witness needs the `Pic^z` redefinition — open, downstream).

## Phases & estimations

| Phase | Status | Iters left | LOC (remaining · realized/it) | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| A.1.c.SubT — line-bundle tensor group law | active; sole productive lane; route reset iter-208 | ~2–4 | ~120–200 · ~0/it (δ-route abandoned; new route bounded) | presheaf-pullback-along-open-immersion sectionwise unfolding (~30–60 LOC) | low — route now bounded single-file (analogist tsroute208) |
| A.1.c — RelPic functor | held (placeholder bodies) | ~3–5 post-SubT | ~50–150 · 0/it | A.1.c.SubT; ét-sheafify on `Over S` | RE-ENGAGE GATE: replace dishonest `PicSharp := const PUnit` + `functorial := 0` first |
| A.2.c — FGA Pic representability (typeclass scaffolding) | priority-2; RR-free | ~12–16 | ~600–800 · 0/it (scaffolding only) | A.1.c | does NOT include the Quot engine below |
| A.2.c-engine — Quot/Cartier construction (discharges the `⟨sorry⟩`s) | not separately started; partial in QuotScheme.lean | ~30–60 | ~2000–4000 · ~0/it | Quot scheme (absent from Mathlib) | the project's single largest build; stays sorry-axiomatized under option (c) until it lands |
| A.3.0/ii/vii — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | ~1100–2100 · 0/it | scheme tangent space; Hilbert poly | absent in Mathlib; likely under-counted |
| A.4 — Albanese UP (Route 2: `rmk:Alb` + autoduality) | gated A.2.c; route committed iter-208 | ~12–20 | ~600–1000 · 0/it | `rmk:Alb` (from representability) + autoduality `J^∨≅J` (theta div) + Galois descent | autoduality is theta-divisor work, RR-free (auditor albroute208) |
| genusZero + `nonempty_jacobianWitness` body | gated A.3 | ~5–7 | ~250–450 · 0/it | tangent-iso + connectedness | hidden A.2.c transit |

**Total Route A**: ~95–150 iters / ~3000–5500 LOC (Route-1 codim cone excised iter-208).

## Routes

`J := Pic⁰_{C/k}` (Kleiman §4–§5, Nitsure §5, Milne III §6). Bottom-up (USER directive):
capacity flows to ungated roots; never a gated target before its roots close; no A.3+
before A.2.c. Default Route-A mode `mathlib-build`; every directive cites
Kleiman/Nitsure/Milne/Mumford/Hartshorne/Stacks/Matsumura/Atiyah–Macdonald.

**Critical path to A.2.c** (all RR-free): A.1.c.SubT (group law) → A.1.c (RelPic functor)
→ A.2.c (representability).

**A.1.c.SubT — line-bundle group law.** The group law is the group of iso-classes of LINE
BUNDLES under tensor — a family of propositions (`Nonempty (… ≅ …)`), not a
monoidal-category instance; mirrors `CommRing.Pic = Units (Skeleton …)`. The one hard
ingredient `tensorObj_restrict_iso` ("⊗ commutes with restriction along an open
immersion") is, since iter-208, on **Route A**: along an open immersion `restrict` is
definitionally sectionwise and the structure-sheaf comparison is the iso `f.appIso`, so
base change is along a ring *isomorphism* (trivially monoidal) — true for arbitrary
`M, N`, needing neither flatness nor a monoidal pullback instance. The sole project-side
gap is a bounded sectionwise unfolding of `PresheafOfModules.pullback` along an open
immersion (~30–60 LOC). The 4-iter abstract-adjoint mate-δ route is **abandoned** (it
reduced to `(PresheafOfModules.pullback φ).Monoidal`, absent multi-file Mathlib infra).
Rationale: `analogies/tsroute208.md`. The iter-207 `restrictScalarsLaxMonoidal` instance
is axiom-clean but now off-path.

**A.2.c — representability is RR-free** (Nitsure §5 + Kleiman §4). Encoded as 6 Prop-valued
typeclasses with `⟨sorry⟩` constructors; downstream Route A proceeds under these.
**Honest scope:** the 600–800 LOC budgets ONLY this typeclass scaffolding. The construction
that discharges the `⟨sorry⟩`s is the Quot/Cartier engine (Quot scheme absent from Mathlib;
partial in `QuotScheme.lean`) — the project's single largest build (its own phase row).
Under option (c), representability stays sorry-axiomatized until that engine lands.

**Albanese UP — Route 2 committed (iter-208, auditor albroute208).** The UP is derived from
`Pic` representability (A.2.c) via Kleiman `rmk:Alb` (Comparison Theorem `th:cmp`), RR-free.
It outputs the UP on the DUAL `J^∨`; landing `isAlbaneseFor` on `J` uses the autoduality
bridge `J^∨ ≅ J`, which is **RR-free** — theta-divisor / Poincaré-sheaf (Milne Thm 6.6,
Lemmas 6.7–6.9; Kleiman `rmk:Jac` / EGK Thm 2.1), plus a minor Galois descent `k̄→k`
(Milne Prop 6.4). This **obsoletes the entire Route-1 Milne-Thm-3.2 cone**, which is hereby
**EXCISED**: `Albanese/CodimOneExtension.lean`, `Albanese/Thm32RationalMapExtension.lean`,
`Albanese/AuslanderBuchsbaum.lean` are dead substrate (removal pending a refactor pass).
The 27-iter-stuck COE / Stacks-02JK node was a **misidentified sub-problem** — Milne's
codim-≥2 step (Thm 3.1) needs only normality + the valuative criterion of properness
(Hartshorne II.4.7), no conormal sequence. (If A.2.c proves far and Route 2 is unavailable,
Route 1 is repairable in ~20–30 LOC via that valuative-criterion proof — not 27 more iters.)

**Route C — Riemann–Roch — PAUSED (USER directive).** Files stay imported with inline
sorries satisfied modulo option (c). Needed only at the three nodes named in Goal.

**Genus-0 arm.** (a) Route-A Pic⁰-via-AV-wrap (transits A.2.c); (b) direct `J := Spec k`
via Mumford rigidity — substrate partial, PAUSED under a USER amendment.

## Open strategic questions

- **`Pic⁰` definition: `degComp` vs `Pic^z`.** `degComp` needs only Pphifin but identifies
  the component by degree (RR-dependent); `Pic^z` is RR-free but needs identity-component /
  clopen-descent infra (~350 LOC). A fully RR-free witness needs `Pic^z`. Decide near A.2.c.
- **USER goal-amendment** (cheapest→costliest): (a) carve Rigidity out of the pause →
  genus-0 closure; (b) full Route C → unconditional end-state; (c) keep option-(c) (current).
- **Genus-0 may need only `AbelianVarietyRigidity`, not `RigidityKbar`** if the target is
  `Spec k` (descent trivial). Audit vs Milne §1.

## Mathlib gaps & new material

**Gaps to fill (Route A).**

- A.1.c.SubT: sectionwise unfolding of `PresheafOfModules.pullback φ` along an open immersion (~30–60).
- A.1.c: ét-sheafify on `Over S`; `LineBundle.OnProduct` carrier (~50–150).
- A.2.c: FGA Pic representability via Quot/Cartier (~600–800).
- A.3.0/ii/vii: scheme tangent space; Hilbert-poly + Pphifin; Pic⁰ AV-structure (~1100–2100).
- A.4 (Route 2): `rmk:Alb` UP from representability; autoduality `J^∨≅J` (theta divisor/Poincaré sheaf); Galois descent `k̄→k`.
- Connected étale group scheme over a field, dim 0 = `Spec k` (~50–100).

**New project material.** AbelianVarietyRigidity, RigidityLemma, Genus0BaseObjects/*,
RiemannRoch/* (paused), Picard/{RelativeSpec, LineBundlePullback, RelPicFunctor,
FGAPicRepresentability, IdentityComponent, Pic0AbelianVariety, QuotScheme,
FlatteningStratification, TensorObjSubstrate}, Albanese/AlbaneseUP. **Excised
(Route-1 dead substrate, removal pending):** Albanese/{CodimOneExtension,
Thm32RationalMapExtension, AuslanderBuchsbaum, CoheightBridge}.
```

## Reference index (titles + what each backs)

- challenge.lean.ref — authoritative formal signatures of the challenge.
- kleiman-picard (arXiv:math/0504020) — Picard scheme; §4 existence, §5 Pic⁰/Jacobian,
  `rmk:Alb` (UP from representability, on J^∨), `rmk:Jac` (autoduality via EGK Thm 2.1).
- nitsure-hilbert-quot — Quot/Hilbert construction (A.2.c engine).
- abelian-varieties (Milne) — Rigidity Thm 1.1; Thm 3.1/3.2 + Prop 3.10 (rational map → AV);
  Albanese UP Prop 6.1/6.4; autoduality Thm 6.6 + Lemmas 6.7–6.9 (theta divisor).
- mumford-abelian-varieties — Rigidity Lemma, theorem of the cube (route-c source).
- hartshorne — genus-0 ≅ ℙ¹; valuative criterion II.4.7.
- fga-explained — collected Kleiman/Nitsure volume.
- matsumura / atiyah-macdonald — commutative algebra (codim-1, Auslander–Buchsbaum).
- stacks-{varieties,fields,algebra,coherent,constructions} — Stacks tags.

## Blueprint chapter titles (one line each — for coverage sanity)

The blueprint has 33 chapters incl.: Picard_{TensorObjSubstrate, RelPicFunctor,
FGAPicRepresentability, QuotScheme, FlatteningStratification, IdentityComponent,
Pic0AbelianVariety, RelativeSpec, LineBundlePullback}; Albanese_{AlbaneseUP,
CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum, CoheightBridge};
RiemannRoch_{WeilDivisor, OCofP, OcOfD, RRFormula, H1Vanishing, RationalCurveIso};
AbelJacobi, Jacobian, Genus, AbelianVarietyRigidity, RigidityKbar, Rigidity,
Differentials, Cohomology_{MayerVietoris,SheafCompose,StructureSheafAb,
StructureSheafModuleK}, Genus0BaseObjects_Cross01Substrate, Cotangent_GrpObj.

## Your task

Render SOUND / DRIFTED / CHALLENGE / REJECT on the strategy, with specific
findings. In particular: is the bottom-up Route-A spine (SubT → RelPic → A.2.c)
the right critical path? Is committing Route 2 (UP on J^∨ + autoduality bridge)
and excising the Route-1 cone sound, or does excising substrate the project may
still need create risk? Is the option-(c) holding posture honestly surfaced?
Write your report to task_results/strategy-critic-clean208.md.
