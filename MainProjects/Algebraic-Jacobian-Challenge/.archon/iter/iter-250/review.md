# Iter-250 (Archon canonical) — review

## Outcome at a glance

- **The "D2′ CLOSES — the canonical critical-path obstacle that held the route flat for 11 iters is
  eliminated, axiom-clean, and the armed BINARY close-or-pivot signal fired POSITIVE" iter.** One
  prover lane, `opus`, mode `prove`:
  - **Lane TS** (`Picard/TensorObjSubstrate.lean`, critical path): the D2′ `(∗∗)` residual at
    `pullbackEtaUnitSquare` is **eliminated**. The proof now ends in a live `erw [Category.assoc,
    ← Functor.map_comp, pullbackSheafifyUnitEtaTriangle f, presheafUnit_comp_map_eta f,
    epsilonPresheafToSheafUnit f]` (no sorry), so `pullbackTensorMap_unit_isIso`
    (`lem:pullback_tensor_iso_unit`, the D2′ closer) closes automatically. Three genuinely-new
    feeder lemmas were authored and proved: `restrictScalarsId_map` (`:= rfl`, the key strip),
    `epsilonPresheafToSheafUnit` (step 7 / substep iii), `pullbackSheafifyUnitEtaTriangle`
    (substep ii). File sorry **2 → 1** (only the separate guard-railed `exists_tensorObj_inverse`
    @ L705 remains).
  - No Lane RPF this iter — `RelPicFunctor` is converged + doc-clean, gated cross-file on D4′.
- **Verification (first-hand by review):** `lean_verify pullbackTensorMap_unit_isIso` →
  `{propext, Classical.choice, Quot.sound}`, **no `sorryAx`**. Full-file `lean_diagnostic_messages`
  (severity=error) → **0 errors**. The "opaque" warning at L478 is a prose comment in
  `tensorObj_restrict_iso`'s docstring — not laundering. The sole term-level `sorry` in the file is
  L705 (`exists_tensorObj_inverse`, separate ⊗-inverse lane, out of scope).
- **Canonical critical-path counter:** the D2′ residual sorry — flat across iters 239–249 — is
  **eliminated this iter.** The *terminal* Picard-cone count is still not zero (chain D3′→D4′→
  `RPF.addCommGroup` + the separate `exists_tensorObj_inverse` remain), and STRATEGY explicitly
  predicts ~3–4 more iters of terminal-count flatness as structural chain-depth lag — NOT renewed
  churn. D2′/D3′/D4′ closures are the tracked intermediate milestones; D2′ is now done.
- **`sync_leanok`** ran at sha `78061c14` (iter 250), **+28 / −0** in `Picard_TensorObjSubstrate.tex`.
- **Blueprint-doctor: 4 broken cross-refs — all 4 target labels EXIST.** The breakage is the
  recurring sync defect: this iter's `sync_leanok` inserted `\leanok` proof markers INSIDE four open
  multi-line `\uses{...}` braces (`lem:islocallyinjective_whiskerleft_via_stalk` proof L1465–1467;
  `lem:eta_bridge_unit_square` proof L3487–3489; the two `tensorobj_*` invertibility blocks at
  L4244–4246 and L4353–4354). Same ROOT defect as iters 246–248, re-firing on different decls.

## The defining tension — RESOLVED: a genuine canonical win, not a 6th "reduce-don't-close"

For the 245–249 arc the pattern was "land axiom-clean helper lemmas, reduce the D2′ residual one
more level, never close" (iter-248 unstuck it: 2/3 ★ mate lemmas closed + the `rfl` linchpin retired
the feared defeq wall; iter-249 assembled the whole abstract telescope into one compiling proof with
a single concrete `(∗∗)` residual). The honest worry going into iter-250 was a 6th instance of the
same shape. **It is not.** The `(∗∗)` residual is eliminated; D2′ closes; both the D2′ closer and its
entire feeder chain verify axiom-clean (no `sorryAx`); the iter-249/250 armed BINARY signal ("did
L1672/L1741 CLOSE? — not did it shrink?") fired **positive**; and the reversing/pivot signal did NOT
fire. The single dominant obstacle this iter was, as predicted, tactical: pervasive `whnf`/`isDefEq`
heartbeat blowups (>6.4M) on `restrictScalars (𝟙)`-over-sheafification composites, defeated by a
propositional `:= rfl` strip lemma + load-bearing `erw` keyed-defeq merge (recorded in the KB).

The two read-only verifiers corroborate independently: **lean-vs-blueprint ts250** — 0 must-fix, all
4 pinned decls faithful to the blueprint, the 2 helpers appropriately project-local; one MINOR stale
prose note (D2′ overview ~L2670–2680 still names the obsolete `δ_comp_η_tensorHom` route). The
**lean-auditor ts250** report — see recommendations.md for its findings.

## Reversing signal — read against outcome

- **iter-249 plan armed signal (BINARY):** "if this prove pass does NOT close L1672, iter-250 runs a
  mathlib-analogist consult." iter-250 plan re-armed it as binary close-or-pivot. → **Close-side
  fired:** D2′ closed. No analogist round, no pivot, no further decomposition needed. The route is
  now genuinely CONVERGING.

## Honest framing for iter-251

1. **Lane TS advances to D3′** (the δ-vs-open-immersion base-change square) — STRATEGY's named "next
   irreducible sub-step." D2′ is no longer a gate. The iter-251 plan should dispatch a prover on D3′
   once its blueprint chapter passes the HARD GATE (`lem:pullback_tensor_map_basechange` and the
   D3′ coherence — confirm `complete + correct` for the relevant chapter blocks first).
2. **The `\leanok`-in-`\uses{}` sync defect re-fired on 4 decls.** This is `\leanok`-owned (sync),
   not review-fixable. The plan agent must reflow the 4 `\uses{}` lists onto single lines (interim
   LaTeX repair) AND the root fix remains user-side (sync must insert `\leanok` after the `}` of a
   multi-line `\uses{}`). It has now persisted across iters 246–248 and 250 — do not let it keep
   re-warning.
3. **Minor blueprint staleness:** D2′ overview paragraph (~L2670–2680) names the pre-iter-246
   `δ_comp_η_tensorHom`/`δ_comp_tensorHom_η` route; the per-lemma proof block is correct. A
   blueprint-writer pass should update the overview when D3′'s chapter is touched.

## Subagent skips

- (none — both highly-recommended review subagents dispatched: lean-auditor ts250,
  lean-vs-blueprint-checker ts250.)
