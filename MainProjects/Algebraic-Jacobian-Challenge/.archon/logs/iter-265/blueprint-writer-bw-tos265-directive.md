# Blueprint-writer directive — bw-tos265

## Chapter to edit
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (consolidated chapter; `% archon:covers`
TensorObjSubstrate.lean + DualInverse.lean among others). Edit ONLY this chapter.

## Why (context slice)
Two active prover lanes read this chapter. A per-file lean-vs-blueprint check this iter found two MAJOR
proof-sketch adequacy gaps — both are contributing to multi-iter stalls. Your job is to expand the two
proof sketches so the prover has the exact, named, step-ordered route. Do NOT change any statement, any
`\lean{...}` target, any signature, or any `% SOURCE`/`% SOURCE QUOTE` block. This is purely additive
proof-sketch detail. Do NOT add `\leanok`/`\mathlibok` markers (the loop manages those).

## Task 1 — Expand the Sq1-tail micro-assembly in `lem:pullback_tensor_map_basechange`
Region: the `\emph{The reduced tail goal.}` paragraph (around lines 4071–4081) and the surrounding Sq1
discussion (≈4044–4116).

The macro route is already described (recover the f- and h-sub-comparison units via
`homEquiv_leftAdjointUniq_hom_app`, reassemble via unit-naturality of `pushforwardComp`/`pullbackComp`).
What is MISSING and must be added:

1. **Pin the P-general recovery brick.** A new axiom-clean lemma was landed last iter:
   `AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app`. It is the **`P`-general** form of the
   already-pinned `leftAdjointUniqUnitEta` (which was the `𝟙_`-specialization, `lem:leftadjointuniq_app_unit_eta`).
   Add a short lemma block (or a clearly-marked sub-statement within the tail discussion) giving it a
   `\lean{AlgebraicGeometry.Scheme.Modules.leftAdjointUniqUnitEta_app}` pin, stating: for a composite
   adjunction `A_φ = (PresheafPullbackPushforwardAdj φ').comp sheafAdj` and `B_φ` its sheaf-level
   counterpart, `A_f.homEquiv P _ ((sheafCompPb f).hom.app P) = B_f.unit.app P`. Note it is the key
   **step-1** brick of the tail and is the P-general twin of `lem:leftadjointuniq_app_unit_eta`.

2. **Spell out the explicit assembly sequence** for `sheafificationCompPullback_comp_tail`, mirroring the
   already-closed `lem:pullbackObjUnitToUnit_comp` (its proof is the `δ`-free analog one sheafification
   layer down). Give the ordered steps in prose (mathematical, NOT Lean tactics — but you MAY name the
   abstract lemmas/natural transformations as mathematical objects):
   - (a) strip the outer `restrictScalars(𝟙)` identity wrapper;
   - (b) distribute the right-hand sheaf composite under `forget` to expose the two sub-comparison factors
     R1 (the f-layer) and R5 (the h-layer) WITHOUT disturbing the left-hand composite unit `B_{h∘f}.unit`;
   - (c) apply `leftAdjointUniqUnitEta_app` to rewrite R1 as `B_f.unit.app P` and R5 as
     `B_h.unit.app (PresheafPullback_f P)`;
   - (d) slide the sheaf-level `pushforwardComp h f` comparison past the recovered units via its
     naturality;
   - (e) reassemble to `B_{h∘f}.unit` via the composite-adjunction unit expansion (`comp_unit_app`) plus
     `unit_naturality`.
   - **Name the precise binding obligation** the prover isolated: the bridge between the presheaf-level
     left-hand side (`pushforward^pre`, `B_{h∘f}.unit`) and the sheaf-level right-hand factors wrapped in
     `forget` requires the compatibility `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget`
     interacting with the recovered `B_f`/`B_h` units. State that this compatibility is the natural place
     to isolate as its own named sub-lemma before the assembly, so the assembly becomes a mechanical paste
     once it is in hand.

3. Add an explicit one-line note that the outer Sq1 lemma `sheafificationCompPullback_comp` consumes this
   tail; keep the existing "transposing the whole tail is circular (verified)" warning.

## Task 2 — Name the ε-naturality helper in `lem:slice_dual_transport` (DUAL naturality step (b))
Region: the `sliceDualTransport` naturality proof sketch (around lines 5832–5848).

The naturality obligation's step (b) (the module-map equation) is described mathematically correctly as
"the ε-naturality square of `restrictScalars` along the structure-ring isomorphism β_W" but does NOT name
the Lean helper the prover needs. Add a sentence (or `% NOTE:`) naming
`PresheafOfModules.restrictScalarsLaxε` (a `NatTrans` whose components are
`Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (α.app X).hom)`) and stating that its `NatTrans`
naturality field delivers exactly the required ε-commutativity-with-restriction-maps square for step (b).
Keep step (a) (`Subsingleton.elim`, thin poset) as written.

Minor (do if cheap): add an inline `\lean{AlgebraicGeometry.Scheme.Modules.presheafDualUnitIso}` pin in
the `lem:dual_unit_iso` proof (it is the scheme-level alias consumed there), and one line in
`lem:dual_restrict_iso` noting the outer `isoMk` naturality is sequenced AFTER
`sliceDualTransport.naturality`.

## Out of scope
- Do NOT touch any statement body, `\lean{}` target name, signature, or `% SOURCE`/`% SOURCE QUOTE` block.
- Do NOT add/remove `\leanok`/`\mathlibok`.
- Do NOT edit any other chapter.
- The `invFun`/`left_inv`/`right_inv` recipe for `sliceDualTransport` is already adequate (per the check) —
  leave it as is.
