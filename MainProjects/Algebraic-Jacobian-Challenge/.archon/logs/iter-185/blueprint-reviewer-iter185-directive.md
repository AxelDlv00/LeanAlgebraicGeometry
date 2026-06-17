# Blueprint Reviewer Directive

## Slug
iter185

## Strategy snapshot

The project formalizes Christian Merten's Jacobian challenge (zero inline `sorry`, kernel-only axioms; protected signatures take `[Field k]` only — NO `CharZero`). Spine = **pointed vs. unpointed**. Witness OBJECT `J` constructed unconditionally; `isAlbaneseFor` universally quantified over `P : 𝟙_ _ ⟶ C`. `genus C := dim_k H¹(C, O_C)`.

Two arms:
- **Positive-genus arm (Route A)** — `J := Pic⁰_{C/k}` per Kleiman §4–§5 + Nitsure §5 + Milne III §6.
- **Genus-0 arm (Route C)** — `J := Spec k` trivial; rigidity over `k̄` via Milne §I.3 + RR-bridge `genus 0 ⟹ ≅ ℙ¹`.

Iter-184 status: `lake build` GREEN, **79 sorries / 0 axioms** (5th consecutive zero-axiom build). Iter-184 was rate-limit-truncated (Anthropic weekly quota): 4 of 10 prover lanes ran (B, E, G, M↓ landed substantive work); 6 NOT_DISPATCHED. The 6 are re-dispatch candidates for iter-185.

### Phases & estimations (verbatim from STRATEGY.md)

| Phase | Status | Iters left | LOC (remaining · realized/it) |
|---|---|---|---|
| A.1.a — RelativeSpec | 5-helper proof landed iter-183; 2 Tier-3 remain | ~3–6 | ~100–250 · ~50/it |
| A.1.b — LineBundle.Pullback | skeleton landed; body gated | ~2–4 | ~200–400 · ~50/it |
| A.1.c — RelPic functor | skeleton landed; body gated | ~10–17 | ~300–500 · ~30/it |
| A.2.a.i — Generic flatness | chapter landed | ~16–28 | ~500–800 · gated |
| A.2.a.ii — Noetherian induction | chapter landed | ~24–42 | ~800–1300 · gated |
| A.2.a.iii — Stratum-glueing | chapter landed | ~20–44 | ~700–1400 · gated |
| A.2.b.i — Grassmannian | chapter landed | ~18–36 | ~600–1100 · gated |
| A.2.b.ii — Flat-locus open subscheme | chapter landed | ~24–48 | ~800–1500 · gated |
| A.2.b.iii — Quot assembly | chapter landed | ~36–72 | ~1200–2400 · gated |
| A.2.c — FGA Pic_{C/k} assembly | skeleton landed; body gated | ~12–16 | ~600–800 · gated |
| **A.3 — Pic⁰ identity + degree** | **chapter LANDED iter-184 plan-phase; file-skeleton owed iter-185** | ~16–28 | ~600–900 · gated |
| A.4.a — Lemma 3.3 codim-1 + Weil-divisor surface | skeleton landed; body gated | ~40–80 | ~1500–2500 · gated |
| A.4.b — Auslander–Buchsbaum | skeleton landed; body gated | ~12–20 | ~500–700 · gated |
| A.4.c.0 — codim-≥2 conclusion (sub-helper exposure owed) | iter-185+ | ~2–4 | ~80–200 · gated |
| A.4.c.1 — Thm 3.2 assembly | helper split landed | ~8–14 | ~400–700 · gated |
| **A.4.d.i — Sym^g C sub-build** | **chapter landed; substrate UNOWNED** | ~10–18 | ~400–700 · gated |
| A.4.d.ii — Albanese UP wiring | skeleton landed; body gated | ~6–10 | ~200–400 · gated |
| Genus-0 rigidity — chart-bridge cross-case body | honest sorry; cocycle-bridge idiom | ~2–4 | ~30–70 |
| Genus-0 rigidity — chart-bridge collapse-at-zero body | honest sorry; Cover.hom_ext | ~2–4 | ~30–70 |
| Genus-0 RR.1 — Weil divisors | active body | ~4–8 | ~150–350 · ~30/it |
| Genus-0 RR.2 — RR formula for genus 0 | skeleton landed; body gated | ~8–12 | ~400–600 · gated |
| Genus-0 RR.3 — O_C(P) global sections | skeleton landed; body gated | ~8–12 | ~400–600 · gated |
| Genus-0 RR.4 — rational ⟹ ≅ ℙ¹ | skeleton landed; body gated | ~8–12 | ~400–600 · gated |
| genusZeroWitness body + k̄→k descent | gated on rigidity + RR bridge | ~7–10 | ~350–850 · gated |
| nonempty_jacobianWitness body | gated on both arms | 1 | <50 · gated |

## Routes
Positive-genus arm = Route A (Picard scheme via FGA) — mandatory.
Genus-0 arm = Route C (Milne §I.3 rigidity) — `J = Spec k` trivial, char-general.

## References

- `references/abelian-varieties.md` → `abelian-varieties.pdf` — Milne, "Abelian Varieties": rigidity (§I.1), `Mor(ℙ¹,A)` constant (§I.3), theorem of the cube (§I.5), Albanese UP of `Pic⁰` (§III.6).
- `references/mumford-abelian-varieties.md` → `mumford-abelian-varieties.pdf` — Mumford, "Abelian Varieties" (TIFR 1970): rigidity (§4), theorem of the cube (§6), scheme version (§10).
- `references/kleiman-picard.md` → `kleiman-picard.pdf` / `-src/*.tex` — Kleiman, "Picard scheme" (FGA Explained 9): existence §9.4, `Pic⁰` §9.5, `Pic^τ` §9.6.
- `references/nitsure-hilbert-quot.md` → `nitsure-hilbert-quot.pdf` / `-src/*.tex` — Nitsure, "Hilbert and Quot Schemes" (FGA Explained 5): Quot construction §5.5.
- `references/fga-explained.md` → `fga-explained.pdf` — collected volume.
- `references/hartshorne-algebraic-geometry.md` → `hartshorne-algebraic-geometry.pdf` — Hartshorne: `Ω_{ℙ¹}≅O(−2)` (Thm II.8.13), `H⁰(ℙ¹,O(−2))=0` (Thm III.5.1), genus-0 + k-point ⟹ ℙ¹ (Ex IV.1.3.5).
- `references/stacks-*.md` → `stacks-*.tex` — Stacks Project chapters (algebra, varieties, fields, coherent, constructions).
- **NEW iter-185 (in flight via reference-retriever 3pdfs)**: `references/leinster-basic-category-theory.md` (Yoneda/limits), `references/atiyah-macdonald-commutative-algebra.md` (Ch.8 primary decomposition, Ch.11 Krull dim), `references/matsumura-commutative-ring-theory.md` (Ch.16–17 depth/regular sequences, Ch.18–19 AB formula / projective dim).

## Focus areas (extra attention this iter)

**(1) NEW chapter just landed:** `blueprint/src/chapters/Picard_IdentityComponent.tex` was written iter-184 plan-phase by the `blueprint-writer pic0-identity-component-chapter` dispatch (561 lines, 5 declarations + 4 proof blocks). Wired into `content.tex`. This chapter has NEVER been reviewed by you. It declares `% archon:covers AlgebraicJacobian/Picard/IdentityComponent.lean` — the corresponding Lean file does **not yet exist** (blueprint-doctor iter-184 flagged this). The expected next step is a file-skeleton prover dispatch for `Picard/IdentityComponent.lean`. **Apply your HARD GATE rigorously**: if the chapter is complete + correct, the file-skeleton can ship iter-185. If not, flag must-fix and dispatch the blueprint-writer to patch.

**(2) Iter-184 review-phase chapter edits** — semantic-marker updates the review agent made (these are NOT planner edits to re-audit, but you may notice if anything else regressed):
  - `Albanese_AuslanderBuchsbaum.tex` L210: `\lean{...}` corrected to `RingTheory.Module.depth_of_short_exact` (FQN fix per lean-vs-blueprint-checker `iter184-auslander`).
  - `Albanese_AuslanderBuchsbaum.tex` L425, L538: `% NOTE (iter-184 review)` comments added re. `exists_isRegular_of_regularLocal` and AB-formula Lean encoding gap-audit.
  - `AbelianVarietyRigidity.tex` L14, L69, L270: `thm:rigidity_genus0_curve_to_AV` → `prop:` (broken `\cref` fix; the iter-184 blueprint-doctor flagged 3 occurrences).
  - `Albanese_AlbaneseUP.tex` L782: same `thm:` → `prop:` fix.

**(3) `Albanese_CodimOneExtension.tex` blueprint-adequacy gap** — `lean-vs-blueprint-checker iter184-codimone` flagged three major issues this iter (not yet acted on by any blueprint-writer):

   a. **must-fix** (per checker): the Mathlib readiness audit at L694–696 makes a false claim ("Mathlib's smoothness predicate `AlgebraicGeometry.Smooth` bundles the regular-local-rings hypothesis") — at b80f227 this is wrong; the implication is a Mathlib gap.
   b. **major**: Stacks 00TT is uncited as the bridge for `Smooth + IsAlgClosed kbar ⟹ IsRegularLocalRing (stalk z)`. An iter-185+ prover cannot derive the route from the blueprint.
   c. **major**: the iter-183 axiom-clean closure `Scheme.ringKrullDim_stalk_eq_coheight` (Krull-dim half) is undocumented in the blueprint — a writer would not know that half is done.
   d. **major**: `mem_domain_iff_exists_partialMap_through_point` (L492 in the Lean file) is promised a `\begin{lemma}` block `lem:mem_domain_partial_map_reshuffle` but has not been added. The "Lean encoding" list item 6 (L678) still carries the retired name `extend_iff_order_nonneg` (renamed iter-179).

   Please reconfirm these findings live in your audit so the plan agent can dispatch a `blueprint-writer codimone-stacks-00tt` this iter to patch the chapter.

**(4) `RiemannRoch_RationalCurveIso.tex` cosmetic** — at L48 and L508 the chapter contains `\texttt{thm:rigidity_genus0_curve_to_AV}` (not a `\cref` so not doctor-flagged, but stylistically inconsistent with the `prop:` correction made iter-184). Minor — flag if you want it cleaned up.

**(5) HARD GATE for iter-185 candidate prover lanes:**

The plan agent is considering these `.lean` files for `## Current Objectives`. Please return your HARD GATE verdict per file (chapter check). Some of these are iter-184 NOT_DISPATCHED re-dispatches with armed recipes; others are continuation lanes.

| Lane | File | Blueprint chapter |
|---|---|---|
| A | `AlgebraicJacobian/RiemannRoch/OCofP.lean` | `RiemannRoch_OCofP.tex` |
| B | `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` | `AbelianVarietyRigidity.tex` (consolidated `% archon:covers`) |
| D | `AlgebraicJacobian/Picard/RelativeSpec.lean` | `Picard_RelativeSpec.tex` |
| E | `AlgebraicJacobian/AbelianVarietyRigidity.lean` | `AbelianVarietyRigidity.tex` (consolidated) |
| F | `AlgebraicJacobian/Picard/QuotScheme.lean` | `Picard_QuotScheme.tex` |
| G | `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` | `Albanese_AuslanderBuchsbaum.tex` |
| H | `AlgebraicJacobian/RiemannRoch/RRFormula.lean` | `RiemannRoch_RRFormula.tex` |
| I | `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` | `RiemannRoch_RationalCurveIso.tex` |
| K | `AlgebraicJacobian/RiemannRoch/OcOfD.lean` | `RiemannRoch_OcOfD.tex` |
| (NEW) | `AlgebraicJacobian/Picard/IdentityComponent.lean` | `Picard_IdentityComponent.tex` |

## Known issues (already on the planner's plate; no need to re-report)

- The 3 broken `\cref{thm:rigidity_genus0_curve_to_AV}` refs flagged by the iter-184 blueprint-doctor were **fixed in the iter-184 review-phase chapter edits** (`thm:` → `prop:`). The iter-185 deterministic doctor will re-run after your review and confirm clean.
- The iter-184 blueprint-doctor `missing_file` covers-problem for `Picard_IdentityComponent.tex` is **deliberate**: the chapter landed iter-184 plan-phase ahead of the Lean file. If your HARD GATE clears the chapter, the iter-185 plan agent dispatches a file-skeleton prover lane to create `Picard/IdentityComponent.lean`. The "missing file" diagnostic resolves automatically.
- The iter-184 lean-auditor's 2 MAJOR findings (GmScaling unused chart-ring-map helpers + AuslanderBuchsbaum underscore-prefix misuse) are scheduled for a future polish iter and are NOT blueprint-correctness issues — no need to surface in your audit.

Report at `.archon/task_results/blueprint-reviewer-iter185.md`.
