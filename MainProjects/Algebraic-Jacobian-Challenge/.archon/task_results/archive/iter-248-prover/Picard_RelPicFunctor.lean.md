# Picard/RelPicFunctor.lean — iter-248 (Lane RPF, mode: prove)

Bounded documentation-hygiene pass. **No proof obligations** — the file already
compiles with 0 file-local `sorry` (the only reachable `sorry` is upstream
`Modules.exists_tensorObj_inverse`, `TensorObjSubstrate.lean:670`). Build verified:
`lake build AlgebraicJacobian.Picard.RelPicFunctor` → `✔ Built (5.8s), Build completed
successfully`. The only warnings are pre-existing `Sheaf.val` deprecation / long-line
lints in `TensorObjSubstrate.lean` (not this file, deferred polish).

## Must-fix items (both addressed)

### (1) Module-status docstring (was L21–49) — RESOLVED
- **Was:** "The single remaining file-local sorry is the `addCommGroup` instance body
  in §1, gated on the Mathlib `Scheme.Modules` monoidal-structure upgrade."
- **Now:** Accurate "## Status (iter-247 rewire — true state)": this file carries **zero
  file-local sorry**; `addCommGroup` has a **real sorry-free body**; the only reachable
  `sorry` is the *upstream* reverse bridge `Modules.exists_tensorObj_inverse` consumed by
  `neg`/`neg_add_cancel` (so a `sorryAx` in `#print axioms` traces to that upstream
  bridge, not a file-local sorry). The old monoidal-upgrade framing is explicitly flagged
  "stale and false". `PicSharp`/`functorial` listed as deliberate stubs gated on Lane TS
  D4′ (`pullback_tensor_iso_loctriv` → `IsInvertible.pullback`).

### (2) `PicSharp` def docstring (was L477) — RESOLVED
- **Was:** excuse-comment "sorry-free placeholder used while the file-local `addCommGroup`
  sorry in §1 is open … gated on the Mathlib `Scheme.Modules` monoidal-structure upgrade".
- **Now:** honest **Tracked gap (cross-file, Lane TS D4′)** note: the `PUnit` constant
  functor is a deliberate stub (no file-local sorry gates it — §1 `addCommGroup` is real);
  the intended group-valued assignment needs `functorial`'s `map_add`, i.e. that pullback
  preserves the tensor-product group law = the loc-triv comparison iso
  `pullback_tensor_iso_loctriv` (Lane TS D4′, `TensorObjSubstrate.lean`,
  `sec:tensorobj_pullback_monoidality`), not yet landed.

## Major items (fixed while in the file)

### (3) `addCommGroup` instance docstring "iter-198 refresh" paragraph — RESOLVED
Replaced the stale "remaining gate … on the tensor-product `AddCommGroup` structure …
Mathlib does not expose a monoidal-category structure on `Scheme.Modules`" paragraph
(which contradicted the accurate iter-247 comment directly below it) with an accurate
account: real sorry-free body built from the upstream substrate coherence isos; only the
upstream inverse bridge is reached; no Mathlib monoidal-upgrade gate. Also removed the
dangling trailing sentence re-asserting the "`Scheme.Modules` monoidal-structure gap".

### (4) `functorial` def docstring (was L524–535) — RESOLVED
Replaced "gated on the same upstream Mathlib upgrade" with the precise D4′ gate: zero hom
is a deliberate stub; `map_zero` is available from `Modules.pullbackUnitIso`; `map_add`
needs `pullback_tensor_iso_loctriv` (= `IsInvertible.pullback`, Lane TS D4′).

### (5) "Note on type expressivity" bullets (was L113–127) — RESOLVED
`addCommGroup` bullet: `OnProduct` carrier is **no longer a typed sorry** (concretised
`LineBundlePullback.lean` iter-188); body real modulo upstream inverse. `PicSharp` /
`functorial` bullets: relabelled as *intended* group-valued constructions, *presently*
`PUnit`/zero stubs pending D4′.

### (6) `etSheaf_group_structure` docstring (was L695–702) — RESOLVED
Removed the false "without depending on the file-local `addCommGroup` sorry body in §1 …
gated on the Mathlib `Scheme.Modules` monoidal-structure upgrade"; restated the gate as
`PicSharp`/`functorial` becoming the real functor (D4′ `pullback_tensor_iso_loctriv`).

### (7) `etSheaf` def docstring (was L669–670) — RESOLVED
Corrected the false "The body … is a typed `sorry`." — the actual body is
`(presheafToSheaf J _).obj (PicSharp.presheaf _C)` (sorry-free, parametric in `J`).
Added that it sheafifies the current stub and becomes the math-correct étale Picard
sheaf once D4′ lands.

## Guardrails honored
- Did NOT build a real `PicSharp`/`functorial` (genuinely cross-file gated on Lane TS
  D4′ `pullback_tensor_iso_loctriv`).
- Did NOT add typed-sorry bridges or re-introduce local substrate duplications.
- File compiles with **0 local sorry** (only the upstream `exists_tensorObj_inverse`
  cone sorry remains). Cited upstream decls, did not copy.
- No proof bodies touched; all edits are docstring/comment text.

## Blueprint markers
No `\leanok` changes needed from me (managed by `sync_leanok`). The chapter
`Picard_RelPicFunctor.tex` already cleared its gate (rpf-fastpath247). No `\lean{}` pin
changes — signatures unchanged.

## Summary
- **Sorry count: 0 local → 0 local** (no proof obligations existed; documentation-only
  lane). Upstream cone sorry `Modules.exists_tensorObj_inverse` unchanged (out of scope,
  Lane TS).
- **Closed:** none (none were open).
- **Fixed:** 7 stale/false docstring blocks (2 must-fix + 5 major/adjacent), all listed
  above. Build re-verified green.
- **Adjacent sorries attempted beyond assigned:** none reachable — the only forward proof
  work (`PicSharp`/`functorial` real bodies) is genuinely blocked cross-file on Lane TS
  D4′, and the directive explicitly forbids building them this iter.

## Why I stopped
**Real progress (documentation-correctness, the assigned deliverable).** This was a
declared documentation-hygiene lane with no proof obligations — the file already had 0
local sorry. I corrected every false/stale claim the lean-auditor flagged (the 2 must-fix
items) plus 5 additional stale docstrings that asserted the same false "file-local
`addCommGroup` sorry gated on a Mathlib `Scheme.Modules` monoidal upgrade" framing, and a
false "etSheaf body is a typed sorry" claim. All now state the true state: real
sorry-free `addCommGroup`, a single *upstream* inverse-bridge sorry, and `PicSharp`/
`functorial` as honest tracked stubs gated on Lane TS D4′ (`pullback_tensor_iso_loctriv`).
The build is green. I stopped because the lane is bounded ("stop when the comments are
accurate") and there is no reachable proof work in this file until D4′ lands upstream —
attempting a real `PicSharp`/`functorial` is explicitly forbidden by the guardrails and
genuinely cross-file-blocked.
