# Recommendations — after iter-265 (for the iter-266 plan agent)

## CRITICAL / HIGH

### 1. ENGINE (`pushPullMap_comp`) is no longer a "cheap convergent pole" — it needs a REFACTOR, not a prove pass
iter-264's STRATEGY framing ("`pushPullMap_comp` is the cheapest remaining REAL decl-close") is now
**refuted**. The mate calculus is done (`pushPull_unit_mate`, axiom-clean) but the pentagon is blocked
by a **kernel `whnf` blow-up** on the two `eqToHom` over-triangle transports in the *definition* of
`pushPullMap`. The prover exhaustively confirmed this is intrinsic to the definition: `simp`/`erw`
telescopes/`subst`/`exact`-helper/`maxHeartbeats 1e6`/`respectTransparency=false` ALL fail (kernel
timeout is not heartbeat-bounded). **Do NOT dispatch another prove pass on `pushPullMap_comp`.** The
sanctioned move is a **refactor** of `pushPullMap` to be transport-light:
- reformulate so the over-triangle substitution `g.left ≫ Y₁.hom = Y₂.hom` is absorbed WITHOUT
  `eqToHom` (e.g. `Over.w`-aware `Functor.mapIso`/whisker the kernel can reduce, or index on the
  structure map as a bundled equality), OR
- prove a kernel-cheap `eqToHom`-cancellation lemma for the `(pushforward q).map ι ≫ eqToHom ≫
  (pushforward p).map π ≫ eqToHom` shape that does NOT whnf pushforward objects.
Consider the **refactor** subagent (changes the def signature; `pushPullMap` is a project decl, not
protected — confirm against `archon-protected.yaml`). A mathlib-analogist (cross-domain) on
"absorbing a structure-map equality into a pseudofunctor map without eqToHom" may also help. After the
refactor, the pentagon close should be cheap (the mate core is already in hand).

### 2. D3′ Sq1 (`sheafificationCompPullback_comp_tail`) — 5th PARTIAL, escalation clock long fired
The bridge `forget_map_pushforward_map` landed axiom-clean and is wired in (genuine 2-step advance),
but the R1/R5 recovery residual remains — the genuinely-novel **non-`rfl`** composite-adjunction
sheafification mate step. pc263/pc264 already armed the STUCK escalation; this is the 5th consecutive
Sq1 PARTIAL. **Do NOT re-dispatch a 6th inline monolith.** The two sanctioned moves:
- (preferred) a **focused `prove` pass building the `hinner`/`hcomp'` twins as `have`s**: reframe
  `forget.map ((pullback h).map (sheafCompPb f .app P).hom)` through the f-adjunction `homEquiv`
  (`Adjunction.homEquiv_naturality_left` on the pullback map) so `leftAdjointUniqUnitEta_app` (L1668,
  axiom-clean, already landed) fires; then slide `(SheafOfModules.pushforwardComp h f).hom` past via
  `.hom.naturality`; collapse `Adjunction.comp_unit_app + unit_naturality` to `B_{h≫f}.unit` (mirror
  model `pullbackObjUnitToUnit_comp` L997-1001). The route is fully specified in-file and in the tos
  lvb report.
- (if it stalls again) a **cross-domain mathlib-analogist** on the bicategorical-cocycle / composite-
  adjunction mate shape.

### 3. DUAL (`sliceDualTransport`) — extract `sliceDualTransportInv`; `naturality` is UNBLOCKED
- `invFun` blocker is mechanical, not conceptual: the deferred `app` metavar under `fun W'' =>` won't
  surface its goal type. Next `prove`/`fine-grained` pass: write a **top-level `noncomputable def
  sliceDualTransportInv`** with the full codomain type spelled out (mirror `homLocalSection`'s `eqToHom`
  conjugation), using `dualUnitRingSwapHom` (the `.hom`-direction `inv ε`, NOT `ε`), then `exact .. ψ`
  at the invFun slot. `left_inv`/`right_inv` then collapse via the new `@[simp]` cancellation lemmas +
  `image_preimage_of_le`.
- **`naturality` is NOT blocked** on building `restrictScalarsLaxε`. The prover's task result and its
  memory note claim that helper "DOES NOT EXIST" — this is **WRONG** (verified this review): it exists
  axiom-clean at `Picard/TensorObjSubstrate/PresheafInternalHom.lean:290` (used there at L326, blueprint
  references it at L5937). The next prover should `open`/reference the existing decl. (Memory + MEMORY.md
  index corrected this review.)
- DUAL remains converging mechanics (not a re-stall) but is a genuine multi-iter sub-hole grind; the
  decl-flat metric is a monolithic-packaging artifact. Do not pivot it to the stalk Plan-B.

### 4. Blueprint defects to route to a blueprint-writer THIS iter (gate-relevant)
Three confirmed blueprint findings (from the per-file lean-vs-blueprint checkers). Per the HARD GATE,
fix `Picard_TensorObjSubstrate.tex` and `Cohomology_CechHigherDirectImage.tex` before re-dispatching
provers on their lanes:
- **(must-fix) `Picard_TensorObjSubstrate.tex` L5859-5863 — mathematical error**: invFun codomain swap
  says "ε(restrictScalars β_{W''}) itself (not inv ε)"; correct is `inv(ε(restrictScalars (f.appIso
  W'').hom.hom))` = `dualUnitRingSwapHom`. A `% NOTE:` flag was added at the spot this review; a
  blueprint-writer must rewrite the prose + add `\lean{}` pins to `dualUnitRingSwapHom` and
  `isIso_ε_restrictScalars_appIso_hom`.
- **(must-fix) `Cohomology_CechHigherDirectImage.tex` `lem:push_pull_functor` — dead `\lean{}` pin +
  under-specified sketch**: the block carries two `\lean{}` pins; `pushPullMap_comp` names a
  non-existent decl (only in a comment), so the statement-block `\leanok` over-marks (carried over from
  the iter-264 `% NOTE`, still un-actioned). Fix: split into two lemma blocks (one per decl; no
  `\leanok` on the `pushPullMap_comp` block until it exists, OR add a `:= sorry` stub). Also: the
  pentagon proof sketch is silent on `pushPull_unit_mate` (the mate core), the `eqToHom` whnf wall, and
  the transport-light reformulation requirement — add these so the next attempt has guidance.
- **(major) missing blueprint entries**: add a `\begin{lemma}\lean{…pushPull_unit_mate}` block (the
  reusable mate-core helper, axiom-clean this iter); add `\lean{}` pins for `dualUnitRingSwapHom`,
  `isIso_ε_restrictScalars_appIso_hom` (DUAL). These are needed for `sync_leanok` to track them.

### 5. lean-auditor major — stale header pointer in `TensorObjSubstrate.lean`
Header (L43-50) "THREE tracked typed-`sorry` residuals (iter-262) … (b) the D3′ Sq1 sub-lemma
`sheafificationCompPullback_comp`" — but that decl is now **sorry-free**; the sorry migrated to the
extracted helper `sheafificationCompPullback_comp_tail` (L2638). A prover acting on the header would
look in the wrong decl. Not blocking, but the plan agent should have the next prover (or a cleanup pass)
fix the header pointer to `sheafificationCompPullback_comp_tail`. (Review cannot edit `.lean`.)

## MEDIUM
- **5 consecutive net-zero file/decl closes on the Picard critical path.** The planner should weigh
  whether the monolithic packaging of `sliceDualTransport` (6 `≃ₗ` fields) and the D3′ Sq1 chain are
  hiding genuine convergence behind a flat metric, vs. a deeper design-shape problem. The engine wall
  (now structural) + the dual metavar-under-binder + the D3′ non-`rfl` mate all point to "the next real
  closes each need ONE focused structural move, not more helpers." A mathlib-analogist (api-alignment)
  on whether these decls should be restructured (e.g. extract `sliceDualTransportInv` as the planner
  already wants) is cheap insurance.
- The engine, D3′, and DUAL are now genuinely independent at the hard step — they can run in parallel
  (engine = refactor lane; D3′ = focused prove; DUAL = `sliceDualTransportInv` build). No coupling.

## Closest-to-completion ranking (for prioritization)
1. **DUAL `invFun`** — mechanical extraction (`sliceDualTransportInv`), all ingredients exist; `naturality`
   unblocked. Most likely to deliver an actual sub-hole close.
2. **D3′ Sq1 R1/R5** — route fully specified, but the mate step is genuinely novel (non-`rfl`); 1-2 iters.
3. **ENGINE `pushPullMap_comp`** — needs a refactor first (transport-light `pushPullMap`); the pentagon
   close is cheap *after* the refactor. Highest-leverage but front-loaded by the structural change.

## Do NOT retry (blocked without a structural change)
- `pushPullMap_comp` via any tactic on the current `pushPullMap` definition — kernel whnf wall is
  intrinsic to the def. Refactor first.
- A 6th inline-monolith attempt on D3′ Sq1 — extract-and-consume or analogist only.
- Building `restrictScalarsLaxε` for DUAL `naturality` — it already exists (PresheafInternalHom.lean:290).
