# Recommendations for the next plan iteration (post iter-250)

## Headline: D2′ is CLOSED. The route advances to D3′.

D2′ (`pullbackTensorMap_unit_isIso` / `lem:pullback_tensor_iso_unit`) closed axiom-clean this iter —
**triple-verified** (review `lean_verify`, lean-auditor ts250, lean-vs-blueprint ts250 all
independently confirm `{propext, Classical.choice, Quot.sound}`, no `sorryAx`, 0 file errors). The
binary close-or-pivot signal armed across iters 249–250 fired POSITIVE. The route is CONVERGING.

## 1. Highest priority — advance Lane TS to D3′

- **D3′ = the δ-vs-open-immersion base-change square** (STRATEGY A.1.c.sub "next irreducible
  sub-step"; blueprint `lem:pullback_tensor_map_basechange` + the D3′ coherence). D2′ is no longer a
  gate; the chain is now D3′ → D4′ → `RPF.addCommGroup`.
- **HARD GATE before dispatch:** confirm the D3′ blueprint blocks are `complete + correct` with no
  must-fix (run blueprint-reviewer / the same-iter fast path on the relevant chapter). STRATEGY's
  reversing signal (line 100–101) warns: if D3′ proves materially harder than its proven unit analog
  `pullbackObjUnitToUnit_comp`, decompose D3′ further (do NOT revive the abandoned Phase-2 route).
- **Reusable patterns from D2′ to hand the D3′ prover** (now in PROJECT_STATUS KB, iter-250):
  propositional `restrictScalarsId_map := rfl` to strip `restrictScalars (𝟙)` wrappers SYNTACTICALLY
  (never `show`/`whnf`); load-bearing `erw` to merge defeq-but-differently-spelled `pushforward`
  images; `letI` CommRing on the `(restrictScalars f).obj 𝟙_` carrier diamond; reading `η F` off the
  goal to avoid `OplaxMonoidal` re-synthesis. Expect heavy `maxHeartbeats` (`.val`-composite friction
  is the recurring obstacle, NOT a Mathlib gap).

## 2. Do NOT retry / blocked

- **`exists_tensorObj_inverse` (L705, lean-auditor must-fix #1)** — the sole tracked open sorry, NOT
  on the D2′→D3′→D4′ critical path. It is the separate guard-railed ⊗-inverse lane with TWO unbuilt
  bridges (C: `dual_isLocallyTrivial`; A: SheafOfModules morphism descent). **Do not blindly
  re-assign a prover to it** without first building those two bridges — it is correctly documented,
  not hidden. The auditor's "must-fix" is the mechanical `:= sorry`-on-load-bearing-claim rule; the
  gap is known and managed, not a regression.
- **DEAD END — do not repeat:** stripping `restrictScalars (𝟙)` via `show …`/`rfl` (the analogist
  eps250 idiom "restrictScalars(𝟙) absorbed cheaply"). It blows >6.4M heartbeats (`whnf` on
  sheafification-laden composites). Also dead: extracting the (∗∗) goal to a standalone lemma (its
  statement-type elaboration itself is catastrophic).

## 3. `.lean` cleanup — bounded pass when a prover next owns `TensorObjSubstrate.lean`

(Review cannot edit `.lean`; route these to the next prover touching the file, e.g. the D3′ lane, or
a `/golf`-style cleanup objective. None block D3′.)

- **MAJOR — stale D2′ "handoff" comment (lines 1452–1476):** states "the SOLE remaining content of
  D2′ is the η-bridge" as open work, but the η-bridge (`pullbackEtaUnitSquare`) is now closed
  directly below it. Misleads a top-down reader. Update to reflect D2′ CLOSED → D3′ next.
- **MAJOR — `set_option backward.isDefEq.respectTransparency false` on `epsilonPresheafToSheafUnit`
  (L1654):** axiom-clean and sound, but the final `rfl` depends on a non-standard unifier option →
  fragile to future Mathlib/Lean elaboration changes. Low urgency; consider hardening the `rfl` into
  an explicit lemma when convenient.
- **MAJOR — deprecated `CategoryTheory.Sheaf.val` (~45 warnings, file-wide incl. new iter-250 decls):**
  maintenance debt; "Use `ObjectProperty.obj`". Not a soundness issue at the current pin, but will
  produce noise / breakage at the next Mathlib bump. Worth a dedicated migration pass eventually.
- **MINOR:** duplicate/stale comment lines 1819–1821 (superseded by 1822–1832, delete); load-bearing
  `erw` chain at L1837 (documented/intentional, fragile — leave but note); docstring of
  `sheafificationCompPullback_eq_leftAdjointUniq` (L1588) overclaims "linchpin" (used inline via
  `rfl`, never called by name); off-path `PullbackLanDecomposition` (L1241–1303) and
  `pullbackObjUnitToUnit_comp` (L900) are documented-dead-within-file (keep if exported API, else
  prune); benign `ext r` and `maxHeartbeats`-comment-proximity linter warnings.

## 4. Blueprint actions (plan agent / blueprint-writer)

- **`\leanok`-in-`\uses{}` sync defect RE-FIRED on 4 decls (blueprint-doctor, this iter).** All 4
  target labels EXIST; `sync_leanok` (+28/−0) inserted `\leanok` inside open multi-line `\uses{...}`
  braces at: `lem:islocallyinjective_whiskerleft_via_stalk` (proof, L1465–1467),
  `lem:eta_bridge_unit_square` (proof, L3487–3489), and the two `tensorobj_*` invertibility blocks
  (L4244–4246, L4353–4354). **Interim fix: reflow each `\uses{}` onto a single line** (LaTeX-syntax
  repair — same fix that held for the prior decl). **Root fix is user-side** (`sync_leanok` must
  insert `\leanok` AFTER the closing `}` of a multi-line `\uses{...}`); surfaced in TO_USER.md. Same
  ROOT defect as iters 246–248 — not a regression of the prior relocation.
- **MINOR stale prose (lean-vs-blueprint ts250):** the D2′ overview paragraph (~L2670–2680 of
  `Picard_TensorObjSubstrate.tex`) still names the obsolete pre-iter-246 `δ_comp_η_tensorHom` /
  `δ_comp_tensorHom_η` route; the per-lemma proof block is correct. Update the overview bullet to the
  actual route (`isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta` δ-wrapping + the unit square) on
  the next blueprint-writer pass — ideally bundled with the D3′ chapter work.

## Closest-to-completion summary
- **Done:** D2′ (the canonical critical-path obstacle of iters 239–249).
- **Next:** D3′ (base-change square), then D4′, then `RPF.addCommGroup`. STRATEGY predicts the
  TERMINAL Picard-cone sorry count stays flat ~3–4 more iters by chain-depth lag — track D3′/D4′
  closures as the real milestones, not the terminal count.
