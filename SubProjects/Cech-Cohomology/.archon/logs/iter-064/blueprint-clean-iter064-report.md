# Blueprint-clean report — iter-064

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Summary

All edits applied cleanly. No `\leanok` or `\mathlibok` markers were touched. No mathematical
content was altered.

---

## `\uses{}` label audit

Every new `\uses{...}` introduced by the decompose-iter064 writer round resolves to an existing
`\label{...}` in the chapter. Checked:

| label | line |
|---|---|
| `def:push_pull_obj` | 298 |
| `def:push_pull_map` | 309 |
| `lem:isIso_modules_of_toPresheaf` | 8010 |
| `lem:pushPull_binary_coprod_prod` | 8031 |
| `lem:restrictFunctorIsoPullback_mathlib` | 8696 |
| `lem:sigmaOptionIso` | 8220 (new) |
| `lem:pushPullObjCongr` | 8245 (new) |
| `lem:over_sigmaOptionIso` | 8266 (new) |
| `lem:piOptionIso` | 8291 (new) |
| `lem:pushPull_coprod_prod_empty` | 8311 (new) |
| `lem:pushPull_coprod_prod` | 8338 (new) |
| `lem:opens_mapMapIso_mathlib` | 10155 |
| `lem:over_postEquiv_mathlib` | 10139 |
| `lem:instIsContinuousOverMapOver_mathlib` | 10165 |
| `lem:functor_isContinuous_comp_mathlib` | 10176 |
| `lem:coverPreserving_overPost_mathlib` | 10186 |
| `lem:slice_overs_equiv_continuity` | 10207 (new) |
| `lem:slice_structureSheaf_hom` | 10051 |
| `lem:slice_reverse_ring_map` | 10254 (new) |
| `lem:pushforward_slice_adjunction_h1` | 10296 (new) |
| `lem:pushforward_slice_adjunction_h2` | 10318 (new) |
| `lem:pushforward_slice_two_adjunction` | 10335 (new) |
| `lem:pushforward_slice_pullback_iso` | 10389 (new) |
| `lem:pushforwardPushforwardAdj_mathlib` | 10122 |
| `lem:leftAdjointUniq_mathlib` | 10111 |
| `lem:sheafOfModules_pullback_mathlib` | 10004 |
| `lem:pullbackPushforwardAdjunction_mathlib` | 10196 |
| `lem:pushforward_obj_obj_mathlib` | 8685 |

No orphaned `\uses{}` found.

---

## Lean leakage stripped (Part A — lines 8194–8399)

| location | issue | fix |
|---|---|---|
| `lem:sigmaOptionIso` proof | `\operatorname{Sigma.}\iota\operatorname{\_desc}`, `\operatorname{coprod.inl\_desc}`, `\operatorname{coprod.inr\_desc}` — Lean lemma names cited in prose | replaced with "universal properties of the coproducts, checked componentwise" |
| `lem:pushPullObjCongr` proof | parenthetical `(\(\operatorname{pushPullMap\_comp}\), \(\operatorname{pushPullMap\_id}\))` | removed; mathematical description of functoriality retained |
| `lem:over_sigmaOptionIso` proof | same Lean lemma names as above | replaced with "universal properties of each coproduct" |
| `lem:piOptionIso` proof | `\operatorname{Pi.}\pi\operatorname{\_lift}`, `\operatorname{prod.lift\_fst}`, `\operatorname{prod.lift\_snd}` | removed; "universal properties of the products" retained |
| `lem:pushPull_coprod_prod` proof | `\(\operatorname{Over.homMk}(\operatorname{Sigma.}\iota\,i)\)` (Lean constructor) | replaced with "the \(i\)-th coproduct inclusion viewed as an over-morphism" |
| `lem:pushPull_coprod_prod` proof | "This framing is mandatory: the downstream section-identification step consumes the forward map as exactly this \(\operatorname{Pi.lift}\) of push--pull maps." — implementation narrative | removed entirely |
| `lem:pushPull_coprod_prod` proof | `(\(\operatorname{Pi.whiskerEquiv}\), \(\operatorname{Sigma.whiskerEquiv}\))` | removed; mathematical description of reindexing isomorphisms retained |
| `lem:pushPull_coprod_prod` proof | "canonical \(\operatorname{Pi.lift}\) of push--pull maps closes the step" | rephrased to "canonical product of push--pull maps" for consistency with rephrased framing |

## Lean leakage stripped (Part B — lines 10207–10447)

| location | issue | fix |
|---|---|---|
| `lem:slice_reverse_ring_map` proof | `(\(\operatorname{sheafPushforwardContinuousComp}\) / \(\operatorname{eqToHom}\))` — `eqToHom` is explicitly listed in the directive as forbidden | removed; "pure equality-transport bookkeeping" retained |
| `lem:pushforward_slice_adjunction_h1` proof | `(\(\operatorname{eqToHom} = \operatorname{eqToHom}\))` in the reduction description | replaced with "an equality of canonical equality-transport isomorphisms … which holds by proof-irrelevance" |

---

## No-touch confirmations

- `\leanok`: not added or removed.
- `\mathlibok`: not touched (4 anchors introduced by writer round remain intact).
- Mathematical content: unchanged.
- `% NOTE:` comments: left as-is (review agent's domain).
