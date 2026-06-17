# Blueprint-clean directive — iter-075

Target: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`.

A blueprint-writer round just added 5 lemma blocks near L8808–L8990
(`lem:pushPull_leg_coherence`, `lem:pushPull_interLegHom_sections`, `lem:backboneIncl_proj`,
`lem:backboneIncl_nerveδ`, `lem:coreIso_objIso_π`) and edited the `\lean{}`/`\uses{}` of
`lem:coreIso_comm_sum` and `lem:coreIso_comm_leg`.

Action: purity pass on the NEW/edited blocks — strip any Lean tactic syntax, project-history or
iter-narrative leakage, and excess verbosity from the proof prose; keep the mathematics. These
are Archon-bespoke results (open-immersion-pushforward naturality) — they carry no external
source, so do NOT demand `% SOURCE` quotes for them. Do not touch `\leanok`/`\mathlibok` markers.
Leave the rest of the (already-clean) chapter alone.
