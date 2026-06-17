# Blueprint Reviewer Directive

## Slug
certify280

## Purpose (read first)
This is a **post-rendering re-certification** pass. Across iters 278–279 the DAG agent ran two
large *rendering-only* cleanup rounds (literal-ref → `\cref`, math-delim normalization,
bare-label, undefined-macro) touching ~24 of the 38 chapters. Those edits were *directed* to
change nothing in statements / proofs / `\lean{}` / `\label{}` / `\uses{}`-semantics, but **no
whole-blueprint review has run since iter-277** (`certify277`). Your job: confirm the rendering
passes introduced no content/semantic damage, and re-confirm the HARD GATE for the chapters
feeding the currently-active prover lane. Read the WHOLE blueprint as usual — the cross-chapter
view is the point.

## Strategy snapshot

### Goal
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`): the nine
protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over the `k`-rational
pointing of a smooth proper geometrically irreducible curve `C/k` (`[Field k]` only; no `C(k)≠∅`,
no `CharZero`). `J := Pic⁰_{C/k}` is built unconditionally; only `isAlbaneseFor` is quantified over
the pointing. End-state: zero inline `sorry` in the dependency cone of each protected decl, 0
project axioms, kernel-only axioms. Posture **option (c)**: forward the Route-A Picard substrate
while Riemann–Roch (Route C) stays frozen by the permanent USER pause.

### Phases & estimations
| Phase | Status | Iters left | Key Mathlib needs | Risks |
|---|---|---|---|---|
| A.1.c.sub — comparison iso on line bundles (loc-triv) | ACTIVE. D3′ STUCK → R1/R5 recovery via `conjugateEquiv_whiskerLeft` (`analogies/d3-mate271.md`), bridge `forget_map_pushforward_map` landed; dual route-2 `sliceDualTransport` CHURNING (leg-B `.hom`-swap infra built; `invFun` needs `sliceDualTransportInv` extraction, then round-trips + naturality) then `dual_restrict_iso` + group inverse | ~18–30 | Sq1 composite-adjunction unit-cocycle; `isIso_of_isIso_restrict` (D4′); ε-naturality `restrictScalarsLaxε` (dual) | both DUAL+D3′ poles |
| A.1.c.fun — RelPic functor on `IsLocallyTrivial` (PARALLEL) | OPENING; author `addCommGroup` + `functorial` vs typed-sorry bridge | ~7–12 | `CommGroup→AddCommGroup` transport; ét-topology on `Over S` | full close gated on A.1.c.sub |
| A.2.c — representability scaffolding | HELD behind A.1.c | ~12–16 | A.1.c | `⟨sorry⟩` constructors discharged by the engine |
| A.2.c-engine — Quot/Cartier (RR-free) | `Rⁱf_*` Čech lane OPEN; DE-COUPLED from D3′. `pushPullMap_id`+`pushPull_unit_mate` LANDED; `pushPullMap_comp` blocked by a KERNEL whnf blow-up | ≈85–140 | `Rⁱf_*` (Čech), Rel Proj, CM-regularity, flattening | DOMINANT pole; comp blocker is DEFINITIONAL |
| A.3 — tangent + Pic⁰ AV-structure | gated A.2.c | ~26–45 | scheme tangent space; Hilbert poly | absent in Mathlib |
| A.4 — Albanese UP (Route 1 RR-free primary) | gated A.2.c | ~12–20 | Milne 3.2/3.10 rigidity + rational-map extension | Route-2 autoduality contingent |
| genusZero + witness body | gated A.3 | ~5–7 | tangent-iso + connectedness | hidden A.2.c transit |

The ⊗-group law is DONE (`picCommGroup` axiom-clean). Critical path (RR-free):
A.1.c.sub → A.1.c.fun → A.2.c.

## Routes
Single primary route (RR-free Route A): `J := Pic⁰_{C/k}` (Kleiman §4–5, Nitsure §5, Milne III §6).
A.1.c.sub carries `Pic X` on `IsInvertible M := ∃N, M⊗N≅𝒪`; the substrate prerequisite
`IsInvertible.pullback` reduces to the comparison iso `f^*(M⊗N)≅f^*M⊗f^*N` on loc-triv pairs
(δ = `pullbackTensorMap`), with the dual-inverse `exists_tensorObj_inverse` taking route-2
(`sliceDualTransport` = leg-A slice-Hom base-change ∘ leg-B unit ε-iso). Route C (Riemann–Roch)
is permanently USER-paused — its chapters (`RiemannRoch_*`) are frozen, NOT a missing route.

## References
- `references/kleiman-picard.md` → Picard scheme (Route A existence/Pic⁰), §4–5.
- `references/nitsure-hilbert-quot.md` → Quot/Hilbert engine (A.2.c-engine).
- `references/abelian-varieties.md` → Milne, rigidity Thm 3.2/3.10 + Albanese UP Prop 6.1/6.4 (A.4).
- `references/stacks-*.md` → Stacks tags backing the cohomology / rigidity-substrate chapters.
- `references/challenge.lean.ref` → authoritative protected signatures.

## Focus areas
Bias extra thoroughness toward the chapters edited by the iters 278–279 rendering passes — verify
the rendering edits did NOT silently alter any statement, proof step, `\lean{}` target, `\label`,
or `\uses{}` semantics, and that every reworded `\cref` resolves to the intended live label:
- **Active prover lane (gate-critical):** `Picard_TensorObjSubstrate.tex` (covers
  `TensorObjSubstrate.lean` + `TensorObjSubstrate/DualInverse.lean`, both carrying live sorries).
  This is the only chapter currently feeding a prover — its `complete + correct` verdict is what
  the loop's HARD GATE depends on.
- **Rendering-touched (content-integrity check):** `Differentials`, `Cohomology_StructureSheafAb`,
  `Cohomology_SheafCompose`, `Rigidity`, `AlgebraicJacobian_Cotangent_GrpObj`, `Picard_RelPicFunctor`,
  `Picard_QuotScheme`, `AbelianVarietyRigidity`, `Albanese_CodimOneExtension`,
  `Albanese_CoheightBridge`, `Albanese_AlbaneseUP`, `Albanese_AuslanderBuchsbaum`,
  `Cohomology_StructureSheafModuleK`, `Cohomology_MayerVietoris`, `Picard_FlatteningStratification`,
  `Picard_IdentityComponent`, `Picard_Pic0AbelianVariety`, `Picard_FGAPicRepresentability`,
  `Picard_RelativeSpec`, `RigidityKbar`.

## Known issues (do NOT re-report — these are standing, acknowledged deferrals)
- **54 uncovered lean-aux** all live in `TensorObjSubstrate.lean` / `DualInverse.lean`, the two
  actively-churning A.1.c.sub prover-lane files (31 live sorries, edited this calendar day). These
  are deferred per standing policy (cover once the lane's sorry count stops moving). Do not flag
  them as a completeness failure; confirming they are the only uncovered set is sufficient.
- **2 ∞-effort nodes** are those same lane's current sorry targets (lean-aux, not blueprint). `archon
  dag-query gaps` is empty (zero ∞ blueprint sources) — confirm, don't re-derive.
- **Route C chapters** (`RiemannRoch_*`) carry residual rendering findings (math-delim / literal-ref);
  Route C is USER-paused, so these are out of current scope — note them only if you find a NON-rendering
  (semantic/correctness) problem.
- **Protected chapters** `Jacobian.tex`, `AbelJacobi.tex` carry a handful of prose literal-refs already
  routed to `TO_USER.md`; the mathematician owns them — do not propose writer fixes for protected files.
- A pre-existing **duplicate `\label{thm:albanese_universal_property}`** (Jacobian.tex:552 vs
  Albanese_AlbaneseUP.tex:99) is known; Jacobian.tex is protected. Report only if it now breaks a
  `\uses{}` resolution (leandag `broken_refs` was 0 last iter).

## What I need from you
1. Per-chapter `complete`/`correct` verdict for all 38 chapters (HARD GATE input).
2. Explicit confirmation (or refutation) that the rendering passes left every statement / proof /
   `\lean{}` / `\label{}` / `\uses{}`-semantic intact — i.e. no content regression slipped in under
   the "rendering-only" banner.
3. A clear `complete + correct` (or not) verdict on `Picard_TensorObjSubstrate.tex` specifically.
4. Unstarted-phase proposals only for phases with genuinely zero coverage (most are HELD/gated, not
   unstarted — check before proposing).
